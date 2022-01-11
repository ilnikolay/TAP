class LogicGate:

    def __init__(self, name):
        self.name = name
        self.output = None

    def getLabel(self):
        return self.name

    def getOutput(self):
        self.output = self.performGateLogic()
        return self.output


class BinaryGate(LogicGate):

    def __init__(self, name):
        super(BinaryGate, self).__init__(name)

        self.pinA = None
        self.pinB = None

    def getPinA(self):
        if self.pinA == None:
            return int(input("Enter Pin A input for gate "+self.getLabel()+"-->"))
        else:
            return self.pinA.getFrom().getOutput()

    def getPinB(self):
        if self.pinB == None:
            return int(input("Enter Pin B input for gate "+self.getLabel()+"-->"))
        else:
            return self.pinB.getFrom().getOutput()

    def setNextPin(self,source):
        if self.pinA == None:
            self.pinA = source
        else:
            if self.pinB == None:
                self.pinB = source
            else:
                print("Cannot Connect: NO EMPTY PINS on this gate")


class AndGate(BinaryGate):

    def __init__(self, name):
        BinaryGate.__init__(self, name)

    def performGateLogic(self):

        a = self.getPinA()
        b = self.getPinB()
        if a==1 and b==1:
            return 1
        else:
            return 0

class OrGate(BinaryGate):

    def __init__(self, name):
        BinaryGate.__init__(self, name)

    def performGateLogic(self):

        a = self.getPinA()
        b = self.getPinB()
        if a ==1 or b==1:
            return 1
        else:
            return 0

class UnaryGate(LogicGate):

    def __init__(self, name):
        LogicGate.__init__(self, name)

        self.pin = None

    def getPin(self):
        if self.pin == None:
            return int(input("Enter Pin input for gate "+self.getLabel()+"-->"))
        else:
            return self.pin.getFrom().getOutput()

    def setNextPin(self,source):
        if self.pin is None:
            self.pin = source
        else:
            print("Cannot Connect: NO EMPTY PINS on this gate")


class NotGate(UnaryGate):

    def __init__(self, name):
        UnaryGate.__init__(self, name)

    def performGateLogic(self):
        if self.getPin():
            return 0
        else:
            return 1


class Connector:

    def __init__(self, fgate, tgate):
        self.fromgate = fgate
        self.togate = tgate

        tgate.setNextPin(self)

    def getFrom(self):
        return self.fromgate

    def getTo(self):
        return self.togate


class NandGate(BinaryGate):

    def __init__(self, name):
        BinaryGate.__init__(self, name)

    def performGateLogic(self):

        a = self.getPinA()
        b = self.getPinB()
        if a==1 and b==1:
            return 0
        else:
            return 1


class NorGate(BinaryGate):
    def __init__(self, name):
        BinaryGate.__init__(self, name)

    def performGateLogic(self):

        a = self.getPinA()
        b = self.getPinB()
        if a ==1 or b==1:
            return 0
        else:
            return 1

class XorGate(BinaryGate):
    def __init__(self, name):
        BinaryGate.__init__(self, name)

    def performGateLogic(self):

        a = self.getPinA()
        b = self.getPinB()
        if a == b:
            return 0
        else:
            return 1

   # TODO
   #  Create a series of gates that prove the following equality: NOT (( A and B) or (C and D)) is that same as NOT( A and B ) and NOT (C and D).
   #  Make sure to use some of your new gates in the simulation.

def main():
   g1 = AndGate("G1")
   g2 = AndGate("G2")
   g3 = OrGate("G3")
   g4 = NotGate("G4")
   c1 = Connector(g1,g3)
   c2 = Connector(g2,g3)
   c3 = Connector(g3,g4)
   print(g4.getOutput())

   g5 = NandGate("G5")
   g6 = NandGate("G6")
   g7 = AndGate("G7")
   c4 = Connector(g5,g7)
   c5 = Connector(g6,g7)
   print(g7.getOutput())

   g8 = XorGate("G8")
   print(g8.getOutput())

main()