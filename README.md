takes in a text file and a positive integer k
writes out a random sequence of words in the flavor of
the input text. 

This flavor is obtained by associating
each k-length prefix in the text with the probability
that it is followed by a certain character. 

Then, starting
from a randomly selected prefix from the text, the prefix
is printed followed by the character chosen randomly with
the probabilities with which the characters actually do
follow the prefix in the input text. 

The prefix is then updated
by shifting the prefix one to the left and appending the chosen 
character, and repeat. Stops when (text character length / 5)
characters have been printed.
