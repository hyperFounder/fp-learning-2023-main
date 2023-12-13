# Makefile for generating the template file for an assignment

NAME = Summative3
FLAGS = flags.hs
EXPORTS = experiments , gameAnnotated , game , odds , oneOf , noun , verb , pronoun , properNoun , determiner , preposition , nominal , np , vp , pp , sent
IMPORTS =  "\nimport Types\n"
#IMPORTS="\nimport Data.List\nimport System.Random\n"

# we generate a "pre-template" from README.md, which then has to be
# converted into the template file by moving out all the data type
# definitions into a separate file Types.hs.  For now this is done
# manually, but it would be nice if it could be done automatically!
TEMPLATE = $(NAME)-PreTemplate.hs

all: $(TEMPLATE)

# this should point to a copy of the fp-learning repository
FPLEARNING=$(HOME)/fp-teaching/FunProg2020/fp-learning/

# this should point to a copy of mdtohs.hs
MDTOHS=$(FPLEARNING)/Resources/mdtohs.hs

$(TEMPLATE): README.md
	cat $(FLAGS) > $(TEMPLATE)
	printf -- "module $(NAME) ($(EXPORTS)) where\n" >> $(TEMPLATE)
	printf -- $(IMPORTS) >> $(TEMPLATE)
	echo >> $(TEMPLATE)
	cat README.md | runhaskell $(MDTOHS) >> $(TEMPLATE)

clean:
	rm $(TEMPLATE)
