#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != 'year' ]]
  then
    ADD_WINNER_TEAM=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
    ADD_OPPONENT_TEAM=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
    if [[ (! $ADD_OPPONENT_TEAM) && (! $ADD_WINNER_TEAM) ]]
    then 
      ADD_WINNER_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER');")
      ADD_OPPONENT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');")
    elif [[ ! $ADD_OPPONENT_TEAM ]]
    then
      ADD_OPPONENT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');")
    elif [[ ! $ADD_WINNER_TEAM ]]
    then
      ADD_WINNER_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER');")
    fi
  WINNER_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
  OPPONENT_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
  ADD_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_TEAM_ID, $OPPONENT_TEAM_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
  fi
done