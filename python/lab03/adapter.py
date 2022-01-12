class EuropeanSocketInterface:
    def voltage(self): pass

    def live(self): pass

    def neutral(self): pass

    def earth(self): pass


# Adaptee
class Socket(EuropeanSocketInterface):
    def voltage(self):
        return 230

    def live(self):
        return 1

    def neutral(self):
        return -1

    def earth(self):
        return 0


# Target interface
class USASocketInterface:
    def voltage(self): pass

    def live(self): pass

    def neutral(self): pass


# The Adapter
class Adapter(USASocketInterface):
    def __init__(self, adapter) -> None:
        self.adapter = adapter

    def voltage(self):
        return 110
    def live(self):
        return self.adapter.live()
    def neutral(self):
        return self.adapter.neutral()

# Client
class ElectricKettle:

    def __init__(self, power):
        self.power = power

    def boil(self):
        if self.power.voltage() > 110:
            print("Kettle on fire!")
        elif self.power.live() == 1 and self.power.neutral() == -1:
            print("Coffee time!")
        else:
            print("No power.")


def main():
    # Plug in
    socket = Socket()
    adapter = Adapter(socket)
    kettle = ElectricKettle(adapter)

    # Make coffee
    kettle.boil()

    return 0


if __name__ == "__main__":
    main()