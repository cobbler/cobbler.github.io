          ### Apt setup
          # Choose, if you want to scan additional installation media
          # (default: false).
          d-i apt-setup/cdrom/set-first boolean false
          # You can choose to install non-free firmware.
          #d-i apt-setup/non-free-firmware boolean true
          # You can choose to install non-free and contrib software.
          #d-i apt-setup/non-free boolean true
          #d-i apt-setup/contrib boolean true
          # Uncomment the following line, if you don't want to have the sources.list
          # entry for a DVD/BD installation image active in the installed system
          # (entries for netinst or CD images will be disabled anyway, regardless of
          # this setting).
          #d-i apt-setup/disable-cdrom-entries boolean true
          # Uncomment this if you don't want to use a network mirror.
          #d-i apt-setup/use_mirror boolean false
          # Select which update services to use; define the mirrors to be used.
          # Values shown below are the normal defaults.
          #d-i apt-setup/services-select multiselect security, updates
          #d-i apt-setup/security_host string security.debian.org
          
          # Additional repositories, local[0-9] available
          #d-i apt-setup/local0/repository string \
          #       http://local.server/debian stable main
          #d-i apt-setup/local0/comment string local server
          # Enable deb-src lines
          #d-i apt-setup/local0/source boolean true
          # URL to the public key of the local repository; you must provide a key or
          # apt will complain about the unauthenticated repository and so the
          # sources.list line will be left commented out.
          #d-i apt-setup/local0/key string http://local.server/key
          # or one can provide it in-line by base64 encoding the contents of the
          # key file (with `base64 -w0`) and specifying it thus:
          #d-i apt-setup/local0/key string base64://LS0tLS1CRUdJTiBQR1AgUFVCTElDIEtFWSBCTE9DSy0tLS0tCi4uLgo=
          # The content of the key file is checked to see if it appears to be ASCII-armoured.
          # If so it will be saved with an ".asc" extension, otherwise it gets a '.gpg' extension.
          # "keybox database" format is currently not supported. (see generators/60local in apt-setup's source)
          
          # By default the installer requires that repositories be authenticated
          # using a known gpg key. This setting can be used to disable that
          # authentication. Warning: Insecure, not recommended.
          #d-i debian-installer/allow_unauthenticated boolean true
