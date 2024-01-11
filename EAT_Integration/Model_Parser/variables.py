"""
Defines variables used across Parsing objects
"""

JIRA_ID = "Jira-ID:"
QTEST_ID = "Qtest-ID:"
LABEL_ID = "Labels:"

# Parsing steps support
MASK_PASSWORD = "masked_password"
MASKED_VALUE = "****"
VARIABLE_REPLACEMENT = "'__VARIABLE__'"

# Pattern for parsing
USER_VAR_PATTERN = r"""\$\{.var\([\'|"](.*?)[\'|"]\)\}"""
USER_VAR_PATTERN_SECURED = r"""\$\{.var_secured\([\'|"](.*?)[\'|"]\)\}"""
ALL_VARIABLES_PATTERN = r"\$\{(.*?)\}"
IGNORE_KEYWORD_MESSAGES_PATTERN = ['(Argument types are:<.*>)']
