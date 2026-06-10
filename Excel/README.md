# 🏒 NHL Statistics Excel Report

## 📊 About the Project

This Excel report provides a detailed visualization of NHL player and team statistics.
The report is interactive, allowing users to filter data by team, season, and game type (Regular Season / Playoffs).

A more detailed project overview is available in the **Introduction** page inside the report.

---

## 📂 Repository Structure

For the workbook to refresh correctly, the folder structure must match exactly:

```
NHL-Statistics/
├── NHL_Statistics.xlsm               ← Main workbook (macros enabled)
└── Data/
    ├── xlsx/
    │   ├── 2021_2022_regular.xlsx    ← Source data – Regular Season
    │   ├── 2021_2022_playoffs.xlsx   ← Source data – Playoffs
    │   └── ...                       ← Future seasons go here
    └── Reference/
        └── Teams_Reference.xlsx      ← Team metadata (names, conferences, divisions)
```

> 📌 **Do not change this folder structure.** Power Query resolves all paths
> relative to the workbook location — moving files will break the data refresh.

---

## 📂 Dataset

The dataset is prepared in **Excel**, with each season divided into:

- **Regular Season**
- **Playoffs**

It includes statistics for **skaters, goalies, and teams**, as well as a separate file with **team metadata**.

- Seasons covered: **2021/2022 – 2025/2026** (2025/2026 playoffs not yet available)

**Sources:**
- Statistics: [NHL.com/stats](https://www.nhl.com/stats)
- Team logos: [EliteProspects.com](https://www.eliteprospects.com/league/nhl)

---

## ⚙️ Technologies Used

| Tool | Purpose |
|---|---|
| **Excel (.xlsm)** | Main report file with macros enabled |
| **Power Query** | Data import and transformation |
| **Power Pivot** | Data modeling and relationships |
| **VBA** | Refresh automation and UI interactions |
| **Conditional Formatting** | Visual highlights in reports |

---

## 🚀 Getting Started

### Option A – Full project (recommended)
1. Download **NHL_Statistics.zip**
2. Extract it — keep the folder structure intact
3. Open `NHL_Statistics.xlsm` and click **Enable Content**
4. Click **Refresh Data** on the Introduction sheet

### Option B – Workbook only
Download `NHL_Statistics.xlsm` standalone.
> ⚠️ Data refresh will not work without the source files.
> Reports are visible but cannot be updated.

---

## 📈 Report Overview

| Sheet | Description |
|---|---|
| **Introduction** | Project description and the Refresh Data button |
| **Skaters Report** | Skater statistics with interactive slicers (team, season, game type) |
| **Goalies Report** | Goalie statistics in a Pivot Table with interactive filters |
| **Teams Report** | League standings sorted by points, split by conference and division |

---

## 🤖 AI Tools Used

- [Claude](https://claude.ai/)
- [ChatGPT](https://chatgpt.com/)
- [Microsoft Copilot](https://copilot.microsoft.com/)

---

## 🔄 Ongoing Updates

This report will be **updated after the end of each NHL Regular Season and Playoffs**
to include the latest season data.

---

## 📩 Contact

If you have any questions or suggestions, feel free to **open an issue** in this repository.
