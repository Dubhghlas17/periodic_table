#!/bin/bash

# periodic table

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]      
      then
      echo Please provide an element as an argument.
      
      else
      NUM_CHECK='^[0-9]+$'

            if [[ $1 =~ $NUM_CHECK ]]
                  then
                  ELE_SEARCH_DIGIT=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1")

                        if [[ -z $ELE_SEARCH_DIGIT ]]                              
                              then
                              echo "I could not find that element in the database."

                              else
                              ELE_SEARCH_DIGIT_RESULT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number = $ELE_SEARCH_DIGIT")
                              echo "$ELE_SEARCH_DIGIT_RESULT" | while IFS="| && " read ATOMIC_NUM NAME SYMBOL TYPE ATOMIC_MASS MELT BOIL
                                                                do
                                                                echo "The element with atomic number $ATOMIC_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
                                                                done
                        fi

            else
            ELE_SEARCH_ALPHA=$($PSQL "SELECT atomic_number FROM elements WHERE symbol ILIKE '$1' OR name ILIKE '$1'")

                  if [[ -z $ELE_SEARCH_ALPHA ]]
                        then
                        echo "I could not find that element in the database."

                        else
                        ELE_SEARCH_ALPHA_RESULT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number = $ELE_SEARCH_ALPHA")
                              echo "$ELE_SEARCH_ALPHA_RESULT" | while IFS="| && " read ATOMIC_NUM NAME SYMBOL TYPE ATOMIC_MASS MELT BOIL
                                                                do
                                                                echo "The element with atomic number $ATOMIC_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
                                                                done
                  fi

            fi
fi
