def bold(func):
    def dec():
        return "<b> " + func() + " </b>"
    return dec

def italic(func):
    def dec():
        return "<i> " + func() + " </i>"
    return dec

def underscore(func):
    def dec():
        return "<u> " + func() + " </u>" 
    return dec