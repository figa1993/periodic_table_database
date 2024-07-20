#! /bin/bash  

if [[ "$1" =~ ^[1-9][0-9]*$  ]]; then
  ELEMENT_DATA=$(psql --username=freecodecamp --dbname=periodic_table -t -c "SELECT * FROM elements WHERE atomic_number=$1")
elif [[ "$1" =~ ^[A-Z][a-z]?$  ]]; then
  ELEMENT_DATA=$(psql --username=freecodecamp --dbname=periodic_table -t -c "SELECT * FROM elements WHERE symbol='$1'")
elif [[ -n "$1"  ]]; then
  ELEMENT_DATA=$(psql --username=freecodecamp --dbname=periodic_table -t -c "SELECT * FROM elements WHERE name='$1'")
else
  echo -e "Please provide an element as an argument."
  exit
fi

if [[ -z $ELEMENT_DATA ]]; then
  echo -e "I could not find that element in the database."
  exit
fi

read ATOMIC_NUMBER UNUSED SYMBOL UNUSED NAME <<< "$ELEMENT_DATA"

ELEMENT_PROPERTIES=$(psql --username=freecodecamp --dbname=periodic_table -t -c "SELECT type_id,atomic_mass,melting_point_celsius, boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")

read TYPE_ID UNUSED ATOMIC_MASS UNUSED MELTING_POINT UNUSED BOILING_POINT <<< "$ELEMENT_PROPERTIES"

TYPE_DATA=$(psql --username=freecodecamp --dbname=periodic_table -t -c "SELECT type FROM types WHERE type_id=$TYPE_ID")
read TYPE <<<"$TYPE_DATA"

echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
