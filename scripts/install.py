
LIB_DIRECTORY = '../lib/'
APP_CONFIGURATION_PATH = LIB_DIRECTORY + 'AppConfiguration.dart'


VERIFY_TOKEN_CONF_VARIABLE_ERROR = -2
VERIFY_TOKEN_CONTINUE = -1
VERIFY_TOKEN_STRUCTURE_ERROR = 0
VERIFY_TOKEN_OK = 1

VERIFY_REQUIRED_OK = "OK"

AVAILABLE_CONF_VALUES = [
    "APP_NAME", "DEFAULT_PROFILE_IMAGE", "DEFAULT_BIG_PROFILE_IMAGE",
    "FACEBOOK_APP_ID", "FACEBOOK_PROTOCOL"
]
REQUIRED_CONF_VALUES = [
    "APP_NAME"
]




def verifyTokens(tokens):
    if tokens[0] == 'class' or tokens[0] == '}':
        return VERIFY_TOKEN_CONTINUE
    if tokens[0] != 'static':
        return VERIFY_TOKEN_STRUCTURE_ERROR
    if tokens[1] != 'const':
        return VERIFY_TOKEN_STRUCTURE_ERROR
    if tokens[2] != 'String':
        return VERIFY_TOKEN_STRUCTURE_ERROR
    if tokens[4] != '=':
        return VERIFY_TOKEN_STRUCTURE_ERROR
    if tokens[5][-1] != ';':
        return VERIFY_TOKEN_STRUCTURE_ERROR
    if tokens[5][0] != '"':
        return VERIFY_TOKEN_STRUCTURE_ERROR
    if tokens[5][-2] != '"':
        return VERIFY_TOKEN_STRUCTURE_ERROR
    if tokens[3] not in AVAILABLE_CONF_VALUES:
        return VERIFY_TOKEN_CONF_VARIABLE_ERROR
    return VERIFY_TOKEN_OK

def verifyRequired(configuration):
    for variable in REQUIRED_CONF_VALUES:
        if variable not in configuration:
            return variable
    return VERIFY_REQUIRED_OK


def getConfiguration():
    configurationFile = open(APP_CONFIGURATION_PATH)
    configuration = {}
    for line in configurationFile:
        line = line.strip()
        tokens = line.split(' ')
        veryValue = verifyTokens(tokens)
        if veryValue == VERIFY_TOKEN_CONTINUE:
            continue
        if veryValue == VERIFY_TOKEN_STRUCTURE_ERROR:
            print("Sintax Error on: " + line)
            print("Example: static const String APP_NAME = \"MyApp\";")
        if veryValue == VERIFY_TOKEN_CONF_VARIABLE_ERROR:
            print("Conf Error on: " + line)
            print(tokens[3] + " is not a config variable")
        configuration[tokens[3]] = tokens[5][1:][:-2]
        veryValue = verifyRequired(configuration)
        if veryValue != VERIFY_REQUIRED_OK:
            print("Conf Error on: " + line)
            print(veryValue + ' is a required conf variable')
        
        
    configurationFile.close()