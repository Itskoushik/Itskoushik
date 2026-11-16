<div align="center">

<img src="assets/hero.svg" width="100%" alt="Koushik Ram — The Engineering Lab. Engineering systems. Automating reality. Building what's next."/>

<br/>

<a href="https://linkedin.com/in/itskoushikram"><img src="https://img.shields.io/badge/LinkedIn-050505?style=for-the-badge&logo=linkedin&logoColor=C2FFC7" alt="LinkedIn"/></a>
<a href="https://itskoushik.netlify.app"><img src="https://img.shields.io/badge/Portfolio-050505?style=for-the-badge&logo=vercel&logoColor=CB9DF0" alt="Portfolio"/></a>
<a href="mailto:koushik.d.ram@gmail.com"><img src="https://img.shields.io/badge/Email-050505?style=for-the-badge&logo=gmail&logoColor=C2FFC7" alt="Email"/></a>
<a href="https://x.com/koushik_ram18"><img src="https://img.shields.io/badge/X-050505?style=for-the-badge&logo=x&logoColor=CB9DF0" alt="X"/></a>

</div>

<br/>

## `01 /` IDENTITY

```
SOFTWARE ENGINEER — Zing Technologies, Bengaluru
Python systems · hardware test automation · serverless
------------------------------------------------------------------------
Built a PyQt5 hardware test platform for HAL's ALH helicopter programme
end to end, cutting stabilisation builds 40 -> 4 across four releases,
zero critical defects from release 3 through sign-off.

Deployed an AWS serverless platform used by 50+ people across 7 teams.

Seeking: Software Engineer roles in product-focused teams.
```

<br/>

## `02 /` CAPABILITY MAP

<table width="100%">
<tr>
<td width="25%" valign="top"><b>PYTHON & HARDWARE AUTOMATION</b><br/><sub>Multi-threaded execution and fault-tolerant device comms, so test runs survive flaky instruments.</sub></td>
<td width="25%" valign="top"><b>BACKEND & REST APIs</b><br/><sub>FastAPI services and MongoDB-backed platforms with API-first design reviews.</sub></td>
<td width="25%" valign="top"><b>TESTING & QUALITY</b><br/><sub>pytest regression suites, unit/integration/functional testing, code review standards.</sub></td>
<td width="25%" valign="top"><b>INSTRUMENT INTEGRATION</b><br/><sub>SCPI/VISA and serial control of oscilloscopes, PSUs, DMMs, audio analyzers, microcontrollers.</sub></td>
</tr>
<tr>
<td valign="top"><b>CLOUD & SERVERLESS</b><br/><sub>AWS Lambda task platform with Python and MongoDB, replacing manual follow-ups.</sub></td>
<td valign="top"><b>DEVOPS & CI/CD</b><br/><sub>Jenkins, Docker, Kubernetes, GitHub Actions pipelines replacing manual release steps.</sub></td>
<td valign="top"><b>AI & COMPUTER VISION</b><br/><sub>OpenCV + MediaPipe pipelines for gaze- and gesture-driven interaction.</sub></td>
<td valign="top"><b>FRONTEND & FULL-STACK</b><br/><sub>React/TypeScript and Next.js interfaces; Ethereum-backed full-stack apps.</sub></td>
</tr>
</table>

<br/>

## `03 /` ENGINEERING IMPACT

<img src="assets/achievement-metrics.svg" width="100%" alt="Engineering impact metrics grouped by source: professional work at Zing Technologies (40 to 4 stabilisation builds, 500+ test cases, 56 pytest scripts, 50+ users across 7 teams, 80% fewer follow-ups, 40% faster execution, 40% fewer aborts, 30% fewer cross-pipeline defects), internship at Pyspiders (60% less setup time, 35% shorter release cycles), personal project EyeCue (77% lower cursor latency) and academic CGPA 8.54."/>

<details>
<summary><b>What is behind the numbers</b></summary>

| Metric | Context |
|---|---|
| 40 → 4 builds | Release 1 to final release; zero critical defects from release 3 |
| 40% fewer mid-test aborts | Fault-tolerant SCPI/VISA layer across 4+ instruments |
| 40% faster execution | SQLite query optimisation and OOP standards |
| 30% fewer cross-pipeline defects | API-first design reviews |
| 80% fewer follow-ups | Serverless task platform, 50+ users, 7 teams |
| 60% / 35% (internship) | 2 microservice test frameworks for 8+ engineers; Jenkins + Docker + Kubernetes + GitHub Actions |

</details>

<br/>

## `04 /` MISSION LOG

<table width="100%">
<tr><th align="left">Timeline</th><th align="left">Role</th><th align="left">Outcomes</th></tr>
<tr>
<td valign="top">Aug 2025 — Present</td>
<td valign="top"><b>Software Engineer</b><br/>Zing Technologies</td>
<td valign="top">Multi-threaded PyQt5 test automation for HAL's ALH helicopter programme; fault-tolerant SCPI/VISA layer; 56-script pytest regression suite; on-site delivery and operator onboarding at HAL; serverless task platform (Python, MongoDB, AWS Lambda); mentored 2 interns.</td>
</tr>
<tr>
<td valign="top">Jun — Jul 2025</td>
<td valign="top"><b>Software Engineer Intern</b><br/>Pyspiders</td>
<td valign="top">Built 2 Python microservice testing frameworks with PyPI packaging; stood up CI/CD pipelines with Jenkins, Docker, Kubernetes, GitHub Actions.</td>
</tr>
<tr>
<td valign="top">Dec 2021 — Jul 2025</td>
<td valign="top"><b>B.E., Information Science & Engineering</b><br/>MVJ College of Engineering, Bengaluru</td>
<td valign="top">CGPA 8.54 / 10.<br/><sub>Certifications: Microsoft Azure AI Essentials · Google Cloud Foundations & Generative AI · Databricks Fundamentals</sub></td>
</tr>
</table>

<br/>

## `05 /` FEATURED BUILDS

### ISTJ — Integrated System Test Jig
**Industrial Hardware Test Automation** · `Python` `PyQt5` `SQLite` `VISA` `SCPI` `Serial`

> **Problem** — Structured hardware test and QA for HAL's ALH helicopter programme needed repeatable, auditable runs across many instruments.

Role-based PyQt5 desktop application that connects to lab instruments over VISA/serial, runs guided test sequences, and generates PDF/Excel reports across engineer, admin and meta-admin roles.

- Multi-threaded control across 5 connector groups (oscilloscope, DMM, PSU, audio analyzer, microcontroller)
- Automated test sequences, equipment self-check, device discovery and recovery, calibration record tracking
- Excel and PDF reporting; role-based access control
- The production platform behind stabilisation builds dropping 40 → 4 across four releases

<img src="assets/istj-architecture.svg" width="100%" alt="ISTJ architecture: operator interface, PyQt5 GUI, device control layer, five hardware instruments, test execution engine, Excel and PDF reporting, with SQLite for authentication, calibration and configuration."/>

**[View Source →](https://github.com/Itskoushik/ISTJ_test_jig)**

<br/>

<table width="100%">
<tr>
<td width="50%" valign="top">

### Fleet Management Dashboard
**Frontend / Systems Design** · `React` `TypeScript` `Vite` `Recharts` `Vitest`

Operator frontend for a fleet of 8 robots (Peppermint SDE-1 challenge). Live telemetry simulation and recorded-log replay feed the same ingestion pipeline.

- Single `ingestEvent()` funnel for all event producers
- Custom `useFleetState` hook as the whole state layer (no Redux)
- Unit-tested `advanceReplay()` drives 1x–10x replay

**[View Source →](https://github.com/Itskoushik/peppermint)**

</td>
<td width="50%" valign="top">

### EyeCue-IntelliSense
**Computer Vision / HCI** · `Python` `OpenCV` `MediaPipe` `PyAutoGUI`

Touch-free cursor control: gaze for movement, MediaPipe Hands gestures for clicks and scroll.

```
CURSOR LATENCY
3.5s ─────────────────► 0.8s  (-77%)
retrained on a cleaner dataset
```

**[View Source →](https://github.com/Itskoushik/EyeCue-IntelliSense)**

</td>
</tr>
<tr>
<td valign="top">

### E-Voting System
**Blockchain / Full-Stack** · `Ethereum` `Solidity` `FastAPI` `MySQL` `JWT`

Votes recorded on-chain through an Ethereum smart contract and cast via MetaMask; candidate and session data in MySQL behind JWT-verified voter access.

<img src="assets/evoting-architecture.svg" width="100%" alt="E-Voting architecture: voter with MetaMask, frontend, FastAPI backend with JWT and MySQL, and an Ethereum smart contract recording votes on-chain."/>

**[View Source →](https://github.com/Itskoushik/E-Voting-System)**

</td>
<td valign="top">

### Hayasaka Music
**Web Engineering** · `Next.js` `JavaScript`

Free music streaming web app: search and stream from the Saavn catalogue, playlists, favourite tracks, automatic queueing of similar songs.

**[View Source →](https://github.com/Itskoushik/hayasaka.music)** · **[Live Demo →](https://hayasakamusic.netlify.app)**

</td>
</tr>
</table>

<br/>

## `06 /` TECH ECOSYSTEM

| | |
|---|---|
| **Languages** | `Python` `JavaScript` `TypeScript` `Java` `C/C++` `SQL` |
| **Frameworks** | `PyQt5` `FastAPI` `React` `Next.js` `Node.js` |
| **Databases** | `MySQL` `MongoDB` `SQLite` `DynamoDB` |
| **Cloud & DevOps** | `AWS Lambda` `GCP` `Docker` `Kubernetes` `Jenkins` `GitHub Actions` |
| **Testing** | `pytest` `Selenium` `Postman` |
| **AI & Vision** | `OpenCV` `MediaPipe` |
| **Blockchain** | `Ethereum` `Solidity` |

<br/>

## `07 /` GITHUB TELEMETRY

<div align="center">

<img src="https://github-readme-stats.vercel.app/api?username=itskoushik&show_icons=true&bg_color=050505&title_color=C2FFC7&text_color=F5F5F5&icon_color=CB9DF0&border_color=C2FFC7" height="170" alt="GitHub statistics"/>
<img src="https://github-readme-stats.vercel.app/api/top-langs/?username=itskoushik&layout=compact&bg_color=050505&title_color=C2FFC7&text_color=F5F5F5&border_color=C2FFC7" height="170" alt="Most used languages"/>

<img src="https://streak-stats.demolab.com/?user=itskoushik&background=050505&ring=C2FFC7&fire=CB9DF0&currStreakLabel=C2FFC7&sideLabels=F5F5F5&border=C2FFC7" height="170" alt="Contribution streak"/>

<img src="https://github-readme-activity-graph.vercel.app/graph?username=itskoushik&bg_color=050505&color=C2FFC7&line=CB9DF0&point=C2FFC7&area=true&hide_border=true" width="95%" alt="Contribution activity graph"/>

</div>

<br/>

## `08 /` CURRENT FOCUS

```
$ cat now-building.txt

Deepening backend and cloud-native systems engineering, and extending
hardware automation experience into general-purpose engineering tools.
Open to Software Engineer opportunities in product-focused teams.
```

<br/>

## `09 /` CONNECT

<div align="center">

<a href="https://github.com/Itskoushik"><img src="https://img.shields.io/badge/GitHub-050505?style=for-the-badge&logo=github&logoColor=C2FFC7" alt="GitHub"/></a>
<a href="https://linkedin.com/in/itskoushikram"><img src="https://img.shields.io/badge/LinkedIn-050505?style=for-the-badge&logo=linkedin&logoColor=CB9DF0" alt="LinkedIn"/></a>
<a href="https://itskoushik.netlify.app"><img src="https://img.shields.io/badge/Portfolio-050505?style=for-the-badge&logo=vercel&logoColor=C2FFC7" alt="Portfolio"/></a>
<a href="mailto:koushik.d.ram@gmail.com"><img src="https://img.shields.io/badge/Email-050505?style=for-the-badge&logo=gmail&logoColor=CB9DF0" alt="Email"/></a>
<a href="https://x.com/koushik_ram18"><img src="https://img.shields.io/badge/X-050505?style=for-the-badge&logo=x&logoColor=C2FFC7" alt="X"/></a>

<img src="assets/footer.svg" width="100%" alt="Build. Break. Understand. Rebuild."/>

</div>
