{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.scheduledShutdown;
in {
  options.services.scheduledShutdown = {
    enable = mkEnableOption "scheduled system shutdown";

    time = mkOption {
      type = types.str;
      default = "22:00";
      description = "Time to shutdown the system (24-hour format, e.g., '22:00' for 10 PM)";
      example = "23:30";
    };

    timezone = mkOption {
      type = types.str;
      default = "local";
      description = "Timezone for the shutdown schedule (use 'local' for system timezone)";
      example = "America/New_York";
    };

    warningMinutes = mkOption {
      type = types.int;
      default = 5;
      description = "Minutes before shutdown to display warning";
      example = 10;
    };

    dryRun = mkOption {
      type = types.bool;
      default = false;
      description = "Enable dry-run mode (log shutdown action instead of actually shutting down)";
    };

    persistent = mkOption {
      type = types.bool;
      default = true;
      description = "Whether the timer should be persistent (run missed schedules on boot)";
    };
  };

  config = mkIf cfg.enable {
    systemd.timers.scheduled-shutdown = {
      wantedBy = ["timers.target"];
      timerConfig = {
        OnCalendar =
          if cfg.timezone == "local"
          then cfg.time
          else "${cfg.timezone} ${cfg.time}";
        Persistent = cfg.persistent;
        RandomizedDelaySec = "30s";
      };
      description = "Timer for scheduled system shutdown";
    };

    systemd.services.scheduled-shutdown = {
      description = "Scheduled system shutdown service";
      serviceConfig = {
        Type = "oneshot";
        User = "root";
        ExecStart = let
          shutdownScript = pkgs.writeShellScript "scheduled-shutdown" ''
            set -euo pipefail

            SHUTDOWN_TIME="${cfg.time}"
            DRY_RUN="${
              if cfg.dryRun
              then "true"
              else "false"
            }"
            WARNING_MINUTES="${toString cfg.warningMinutes}"

            log() {
              echo "$(date '+%Y-%m-%d %H:%M:%S') [scheduled-shutdown] $1"
              logger -t scheduled-shutdown "$1"
            }

            if [ "$DRY_RUN" = "true" ]; then
              log "DRY RUN: Would shutdown system at $SHUTDOWN_TIME (warning: ''${WARNING_MINUTES}min before)"
              exit 0
            fi

            log "Initiating scheduled shutdown at $SHUTDOWN_TIME"

            # Send warning to all logged-in users
            if [ "$WARNING_MINUTES" -gt 0 ]; then
              log "Sending shutdown warning ($WARNING_MINUTES minutes)"
              ${pkgs.util-linux}/bin/wall "SCHEDULED SHUTDOWN: System will shutdown in $WARNING_MINUTES minutes at $SHUTDOWN_TIME. Save your work now!"

              # Wait for warning period
              sleep $((WARNING_MINUTES * 60))
            fi

            # Final warning
            ${pkgs.util-linux}/bin/wall "SCHEDULED SHUTDOWN: System is shutting down NOW!"
            log "Executing system shutdown"

            # Shutdown the system
            ${pkgs.systemd}/bin/systemctl poweroff
          '';
        in "${shutdownScript}";
        StandardOutput = "journal";
        StandardError = "journal";
      };
    };

    # Log service enablement
    system.activationScripts.scheduledShutdownInfo = lib.stringAfter ["etc"] ''
      echo "[scheduled-shutdown] Service enabled - shutdown scheduled for ${cfg.time}${optionalString cfg.dryRun " (DRY RUN MODE)"}"
    '';
  };
}
