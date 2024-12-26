{pkgs}: {
  channel = "stable-23.11";
   packages = [
    (pkgs.flutter.override {
      version = "3.27.1";
      hash = "sha256-0mz7K6QA9zZZvz/+2/X5Zr2Vx9+Yy+cEBQKvx9MHCA="; # Latest Flutter hash
    })
    pkgs.nodePackages.firebase-tools
    pkgs.jdk17
    pkgs.unzip
  ];
  idx.extensions = [];
  idx.previews = {
    previews = {
      web = {
        command = [
          "flutter"
          "run"
          "--machine"
          "-d"
          "web-server"
          "--web-hostname"
          "0.0.0.0"
          "--web-port"
          "$PORT"
          "--dart-define"
          "BACKEND_URL=https://backend-fastapi-gemini-lexmachina-916007394186.asia-south1.run.app"
        ];
        manager = "flutter";
      };
      android = {
        command = [
          "flutter"
          "run"
          "--machine"
          "-d"
          "android"
          "-d"
          "emulator-5554"
          "--dart-define"
          "BACKEND_URL=https://backend-fastapi-gemini-lexmachina-916007394186.asia-south1.run.app"
        ];
        manager = "flutter";
      };
    };
  };
}
