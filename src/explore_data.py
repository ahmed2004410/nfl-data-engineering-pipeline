from pathlib import Path
import pandas as pd

RAW = Path("data/raw")

# 1) الملفات الصغيرة: نقراها كاملة
games = pd.read_csv(RAW / "games.csv")
players = pd.read_csv(RAW / "players.csv")
plays = pd.read_csv(RAW / "plays.csv")

# 2) ملف الـ tracking الكبير: نقرا 3 أعمدة بس
tracking_keys = pd.read_csv(
    RAW / "week_data.csv",
    usecols=["gameId", "playId", "nflId"],
)

print("=== الأعمدة وأنواعها ===")
for name, df in [("games", games), ("players", players), ("plays", plays)]:
    print(f"\n--- {name} ({len(df)} rows) ---")
    print(df.dtypes.to_string())

print("\n--- week_data  ---")
print(tracking_keys.dtypes.to_string())

print("\n=== Coverage Check ===")
trk_games = tracking_keys["gameId"].nunique()
trk_plays = tracking_keys[["gameId", "playId"]].drop_duplicates()

print("Games in games.csv:      ", games["gameId"].nunique())
print("Games in plays.csv:      ", plays["gameId"].nunique())
print("Games in tracking:       ", trk_games)
print("Plays in plays.csv:      ", len(plays))
print("Plays that have tracking:", len(trk_plays))

merged = plays[["gameId", "playId"]].merge(
    trk_plays, on=["gameId", "playId"], how="left", indicator=True
)
print("Plays WITHOUT tracking:  ", (merged["_merge"] == "left_only").sum())

print("\n=== Keys ===")
print("plays (gameId, playId) unique?:",
      not plays.duplicated(["gameId", "playId"]).any())
print("tracking nflIds missing from players.csv:",
      len(set(tracking_keys["nflId"].dropna().unique()) - set(players["nflId"])))