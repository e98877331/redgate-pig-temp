
@outputSchema("word:chararray")
def helloworld():
    return 'Hello, World'

@outputSchemaFunction("mergeBagSchema")
def mergeBag(word):

    # print "CYY0: " + str(type(word))
    # print "CYY1: " + str(word)
    # sub = word[0]

    # print "CYY0: " + str(type(sub))
    # print "CYY1: " + str(sub)
    length = len(word)
    if length < 2:
        return word

    l = []
    for i in xrange(len(word[0])):
        for j in xrange(length):
            if word[j][i] is not None:
                l.append(word[j][i])
                break
            if j == length - 1:
                l.append("")

    print "CYY: " + str(l)
    return [tuple(l)]

@schemaFunction("mergeBagSchema")
def mergeBagSchema(input):
    # print "schema: " + str(input)
    return input
