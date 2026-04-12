const path = require("path");

module.exports = {
  apps: [
    {
      name: "luniverso-site",
      cwd: path.join(__dirname, "luniverso-site"),
      script: "node_modules/.bin/next",
      args: "start --port 3000",
      restart_delay: 3000,
    },
    {
      name: "luniverso-game",
      cwd: path.join(__dirname, "luniverso-game"),
      script: "dist/server.js",
      env_file: ".env.production",
      restart_delay: 3000,
    },
  ],
};
