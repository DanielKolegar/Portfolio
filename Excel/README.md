# 🏒 NHL Statistics Excel Report

## 📊 About the Project

This Excel report provides a detailed visualization of NHL player and team statistics.
The report is interactive, allowing users to filter data by team, season, and game type (Regular Season / Playoffs).
A more detailed project overview is available in the **Introduction** page inside the report.

> ⚠️ **Compatibility note:** This project requires **Microsoft Excel for Windows** with Power Query and Power Pivot support.
> Excel for Mac and Excel Online are **not supported** due to VBA and Power Pivot limitations.

---

## 📂 Repository Structure

For the workbook to refresh correctly, all files must be kept in the **same folder**:

```
NHL-Statistics/
├── NHL_Statistics.xlsm        ← Main workbook (macros enabled)
├── 2021_2022_regular.xlsx     ← Source data – Regular Season
├── 2021_2022_playoffs.xlsx    ← Source data – Playoffs
└── Teams_Reference.xlsx       ← Team metadata (names, conferences, divisions)
```

> 📌 **Do not move source files into subfolders.** Power Query resolves paths
> relative to the workbook location — all files must sit in the same directory.

---

## 📂 Dataset

The dataset is prepared in **Excel**, with each season divided into:

- **Regular Season**
- **Playoffs**

It includes statistics for **skaters, goalies, and teams**, as well as a separate file with **team metadata**.

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

## 🔧 Power Query – Dynamic Paths

Power Query paths are resolved **dynamically at runtime** — no hardcoded file paths.

The workbook uses a helper query (`WorkbookPath`) that reads the current workbook's
location and builds all source file paths relative to it:

```m
// WorkbookPath query
let
    FullPath   = Excel.CurrentWorkbook(){[Name="WorkbookPath"]}[Content]{0}[Column1],
    FolderPath = Text.BeforeDelimiter(FullPath, "\", {0, RelativePosition.FromEnd})
in
    FolderPath & "\"
```

Each data query then references `WorkbookPath` instead of a hardcoded drive letter,
so the workbook works on any machine without any manual path changes after cloning.

---

## 🤖 VBA – RefreshData Macro

The workbook includes a `RefreshData` macro that refreshes all Power Query connections
and the Power Pivot data model in the correct order.

**What it does:**

1. Refreshes all Power Query connections (`ActiveWorkbook.Connections`)
2. Refreshes the Power Pivot model (`ActiveWorkbook.Model.Refresh`)
3. Refreshes all Pivot Tables across all sheets
4. Displays a confirmation message when complete

**How to run it:**

- Click the **Refresh Data** button on the Introduction sheet, or
- Open the VBA editor (`Alt + F11`) and run `RefreshData` manually

> 💡 The macro uses `BackgroundQuery = False` to ensure each step completes
> before the next one starts — preventing stale Pivot Table data.

---

## 🚀 Getting Started

1. **Clone or download** this repository so all files are in the same folder.
2. **Open** `NHL_Statistics.xlsm` in Excel for Windows.
3. If prompted, click **Enable Content** to allow macros.
4. Click the **Refresh Data** button on the Introduction sheet (or run the macro manually).
5. All Pivot Tables and reports will update automatically.

---

## 📈 Report Overview

| Sheet | Description |
|---|---|
| **Introduction** | Project description and the Refresh Data button |
| **Skaters Report** | Skater statistics with interactive slicers (team, season, game type) |
| **Goalies Report** | Goalie statistics in a Pivot Table with interactive filters |
| **Teams Report** | League standings sorted by points, split by conference and division |

---

## 🔄 Ongoing Updates

This report will be **updated after the end of each NHL Regular Season and Playoffs**
to include the latest season data.

When new season files are added, place them in the same folder as the workbook
and update the Power Query source references accordingly.

---

## 📩 Contact

If you have any questions or suggestions, feel free to **open an issue** in this repository.
