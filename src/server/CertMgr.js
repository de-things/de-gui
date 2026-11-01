// !!! IMPORTANT !!!
// TO MAKE THIS FILE WORK INSTALL 'openssl' CLI TOOL FIRST

import * as ConfigMgr from "./ConfigMgr.js";
import fs from "fs"
import { execSync } from "child_process"
import { stderr } from "process";

function checkCert() {
    if (!fs.existsSync(ConfigMgr.cert_path())) return;

    const cert_files = fs.readdirSync(ConfigMgr.cert_path());
    return cert_files.includes("server.crt") && cert_files.includes("server.key") && cert_files.includes("trusted.crt")
}

export function init() {
    if (ConfigMgr.address() == "0.0.0.0") {
        console.error("Seems server address is set to '0.0.0.0', which is a default value.")
        console.error("You need to specify server public IP in 'config.json' before running the server.");
        console.error("Replace this with your server public IP: {\"address\": \"0.0.0.0\"}");
        process.exit(1);
    }

    if (!checkCert()) {
        console.log("Cannot find proper certificate files, recreating...");
        execSync(`./mkcert.sh ${ConfigMgr.address()} ${ConfigMgr.cert_path()}`);
    }
    else {
        console.log(`Certificate files path: ${ConfigMgr.cert_path()}`);
    }
}

export default {}