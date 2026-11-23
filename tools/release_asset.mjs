import { execFileSync } from "node:child_process";
import { createHash } from "node:crypto";
import { copyFileSync, mkdirSync, readFileSync, writeFileSync } from "node:fs";

const releaseZip = "release/BestClassicWB.zip";
const releaseManifest = "release/manifest.json";
const buildTools = [
  "tools/distribution.py",
  "tools/package.py",
  "tools/package-requirements.txt",
];

function sha256(data) {
  return createHash("sha256").update(data).digest("hex");
}

function buildInputsHash(commit) {
  const tree = execFileSync("git", ["ls-tree", "-z", commit, "--", "src", ...buildTools]);
  const catalogue = execFileSync("git", ["ls-tree", "-z", commit + ":packages"], { encoding: "utf8" });
  const manifests = catalogue.split("\0").filter((entry) => entry.endsWith(".json"));
  return sha256(Buffer.concat([tree, Buffer.from(manifests.join("\0"))]));
}

function readJson(path) {
  return JSON.parse(readFileSync(path, "utf8"));
}

function stage(commit, zip, verification) {
  if (!/^[a-f0-9]{7,40}$/.test(commit)) {
    throw new Error("Supply the Git commit used to build and verify the release ZIP.");
  }
  const changes = execFileSync("git", [
    "status", "--porcelain", "--untracked-files=all", "--", "src", ":(glob)packages/*.json", ...buildTools,
  ]);
  const inputsSha256 = buildInputsHash(commit);
  if (changes.length || inputsSha256 !== buildInputsHash("HEAD")) {
    throw new Error("The release build inputs differ from the locally verified commit.");
  }
  const report = readJson(verification);
  const zipSha256 = sha256(readFileSync(zip));
  if (report.status !== "matched" || report.zipSha256 !== zipSha256) {
    throw new Error("The release ZIP must match a passing local release verification report.");
  }

  mkdirSync("release", { recursive: true });
  copyFileSync(zip, releaseZip);
  writeFileSync(releaseManifest, JSON.stringify({ zipSha256, inputsSha256 }, null, 2) + "\n");
  console.log("Staged the locally verified ZIP in " + releaseZip + ".");
}

function verify() {
  const { zipSha256, inputsSha256 } = readJson(releaseManifest);
  if (buildInputsHash("HEAD") !== inputsSha256) {
    throw new Error("The release build inputs changed. Verify and stage an updated ZIP before publishing.");
  }
  if (sha256(readFileSync(releaseZip)) !== zipSha256) {
    throw new Error("The staged ZIP does not match the locally verified release checksum.");
  }
  console.log("Loaded the locally verified ZIP (" + zipSha256 + ").");
}

const [command, ...args] = process.argv.slice(2);
try {
  if (command === "stage" && args.length === 3) {
    stage(...args);
  } else if (command === "verify" && args.length === 0) {
    verify();
  } else {
    throw new Error("Use stage <verified-commit> <zip> <verification.json> or verify.");
  }
} catch (error) {
  console.error(error.message);
  process.exitCode = 1;
}
