import fs from "fs";
import crypto from "crypto";
import path from "path";

var config;

export var public_path = () => "./public";
export var cert_path = () => "./.cert";
export var db_path = () => "./.cluster";
export var address = () => config.address;
export var port = () => config.port;
export var request_max_bytes = () => config.request_max_bytes;
export var secret = () => config.secret;
export var cert_crt = () => config.cert_crt;
export var cert_key = () => config.cert_key;

export var credentials = () => {
    return {
        cert: fs.readFileSync(path.join(cert_path(), cert_crt())),
        key:  fs.readFileSync(path.join(cert_path(), cert_key())),
    }
}

const CONFIG_DEFAULTS = {
    address: "0.0.0.0",
    port: 1984,
    request_max_bytes: 102400,
    secret: crypto.randomBytes(16).toString("hex"),
    cert_crt: "server.crt",
    cert_key: "server.key",
}

/** initializes config data */
export function init() {
    console.log("Validating config data...");
    
    // create config.json if does not exist
    if (!fs.existsSync("config.json")) {
        fs.writeFileSync("config.json", JSON.stringify(CONFIG_DEFAULTS, null, 2));
        console.log("Created './config.json' file.");
    }

    config = JSON.parse(fs.readFileSync("config.json", { encoding: "utf-8" }));

    if (Object.keys(CONFIG_DEFAULTS).filter(key => !Object.keys(config).includes(key)).length > 0) {
        console.log("'./config.json' content is invalid. Please delete 'config.json' and restart server to recreate it.");
        process.exit(1);
    }
    
    if (!fs.existsSync(db_path())) {
        fs.mkdirSync(db_path());
        console.log(`Created database path: ${db_path()}`);
    }
}

export default {}