#!/bin/bash

# validates HTML page
# discards warnings about things which are valid in HTML 5

if [ $# -eq 0 ]
then
    echo "No arguments supplied"
    echo "Usage:"
    echo "  ./validate-html.sh file.html"
    exit 255
fi

tidy -errors -utf8 $1 2>&1 | egrep -v "<[/]*header>|<[/]*main>|<[/]*footer>|<[/]*nav>|<script> inserting \"type\""

