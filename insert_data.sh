#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

queries=""
while IFS=, read -r year round winner opponent winner_goals opponent_goals
do
  [[ $year == "year" ]] && continue
  queries+="
    INSERT INTO teams(name) VALUES ('$winner'), ('$opponent') ON CONFLICT (name) DO NOTHING;
    INSERT INTO games(year, winner_id, opponent_id, winner_goals, opponent_goals, round)
    VALUES (
      $year,
      (SELECT team_id FROM teams WHERE name = '$winner'),
      (SELECT team_id FROM teams WHERE name = '$opponent'),
      $winner_goals,
      $opponent_goals,
      '$round'
    );"
done < games.csv

$PSQL "$queries"
