# Instruction

## Handles

In short, handles are objects to allow for access to any signal name in your HDL design.

In a previous tutorial, talking to sim, we saw how to get and set values in a simulation via handles. We assign and read values from handles via `dut.<signal name>.value`.

## Handle values

Accessing the value property of a handle object will return a `BinaryValue` object. Any unresolved bits are preserved and can be accessed using the binstr attribute, or a resolved integer value can be accessed using the integer attribute.

### BinaryValue

`BinaryValue` is of the following form:

```
BinaryValue(value=None, n_bits=None, bigEndian=True, binaryRepresentation=0, bits=None)
```

And has the following methods:

* BinaryValue.integer is an integer
* BinaryValue.is_resolvable is unknown or not (X,Z,U are considered unresolvable or unknown): true = resolvable | false = unresolvable
* BinaryValue.signed_integer is a signed integer
* BinaryValue.binstr is a string of “01xXzZ”
* BinaryValue.buff is a binary buffer of bytes
* BinaryValue.n_bits is number of bits of binary value
* BinaryValue.value is an integer (deprecated)
* BinaryValue.get_value is an integer (deprecated)

#### Creating, Reading, and Writing a BinaryValue

Run the code below to get familiar with BinaryValues manipulations:

```
# Get familiar with BinaryValue
from cocotb.binary import BinaryRepresentation, BinaryValue

bv = BinaryValue(10, 8, True, BinaryRepresentation.TWOS_COMPLEMENT)
print("===============================================================")
print("BinaryValue(10, 8, True, BinaryRepresentation.TWOS_COMPLEMENT)")
print("bv.get_value(): " + str(bv.get_value()))
print("bv.integer: " + str(bv.integer))
print("===============================================================")

print()


bv =  BinaryValue('XzZx0100', 8, True, BinaryRepresentation.TWOS_COMPLEMENT)
print("===============================================================")
print("BinaryValue('XzZx0100', 8, True, BinaryRepresentation.TWOS_COMPLEMENT)")
print("bv.is_resolvable: "+ str(bv.is_resolvable))
print("bv.binstr: "+ str(bv.binstr))
print("===============================================================")

print()


bv = BinaryValue('10000000', 8, True, BinaryRepresentation.TWOS_COMPLEMENT); 
print("===============================================================")
print("BinaryValue('10000000', 8, True, BinaryRepresentation.TWOS_COMPLEMENT)")
print("bv.get_value_signed(): " + str(bv.get_value_signed()))
print("bv.signed_integer: " + str(bv.signed_integer))
print("===============================================================")

print()

bv = BinaryValue(n_bits=10, bigEndian=False, binaryRepresentation=BinaryRepresentation.TWOS_COMPLEMENT)
bv.integer = -128
print("===============================================================")
print("bv = BinaryValue(n_bits=10, bigEndian=False, binaryRepresentation=BinaryRepresentation.TWOS_COMPLEMENT)")
print("bv.integer = -128")
print("bv.get_value_signed: " + str(bv.signed_integer))
print("bv.get_value_signed: " + str(bv.n_bits))
print("===============================================================")
```

#### BinaryRepresentation

As we saw in the example above, `BinaryRepresentation` is a argument to `BinaryValue` which we can set. `BinaryRepresentation` is a simple class denoting one of three types of binary representations:

```
class BinaryRepresentation:  # noqa
    UNSIGNED = 0  #: Unsigned format
    SIGNED_MAGNITUDE = 1  #: Sign and magnitude format
    TWOS_COMPLEMENT = 2  #: Two's complement format
```

#### BinaryValue Deprecation

There is talk that BinaryValue will be phased out in upcoming cocotb releases. The Datatypes Logic will take its place which is discussed below.

### HDL Datatypes

From the cocotb docs on HDL Datatypes:

```
They can be used independently of cocotb for modeling and will replace BinaryValue as the types used by cocotb’s simulator handles.
```

#### Bit, Logic & LogicArray

* `Logic` is a model of the 4-value (0, 1, X, Z) datatype commonly seen in HDLs. `Logic` can be converted to and from `int`, `str`, `bool` and `Bit` by using the appropriate constructor syntax. 
* `Logic` can be put into `LogicArrays`.
* `Bit` is a model of a 2-value datatype commonly seen in HDL.

Run the code below to get familiar with `Logic` and `LogicArray` manipulations

```
from cocotb.types import Bit,Logic, LogicArray
from cocotb.types.range import Range

print('Logic("X"): ' + str(Logic("X")))

print("Logic('X'): " + str(Logic('X')))

print("Logic(True): " + str(Logic(True)))

print("Logic('1'): " + str(Logic('1')))

print("Logic(1): " + str(Logic(1)))

print("Logic(Bit(0)): " + str(Logic(Bit(0))))

print("Logic('0'): " + str(Logic('0')))

print("Logic(): " + str(Logic()))

print('Logic("01XZ").binstr: ' + LogicArray("01XZ").binstr)

print("LogicArray('01XZ', Range(3, 'downto', 0)): " + LogicArray('01XZ', Range(3, 'downto', 0)).binstr)

print('LogicArray([0, True, "X"]): ' + LogicArray([0, True, "X"]).binstr)

print("LogicArray('01X', Range(2, 'downto', 0))" + LogicArray('01X', Range(2, 'downto', 0)).binstr)

print("LogicArray(0xA).integer: " +    str(LogicArray(0xA).integer))         

print("LogicArray('1010', Range(3, 'downto', 0)): " + LogicArray('1010', Range(3, 'downto', 0)).binstr)

print('LogicArray(-4, Range(0, "to", 3)).signed_integer : ' + str(LogicArray(-4, Range(0, "to", 3)).signed_integer)) # will sign-extend

print("LogicArray('1100', Range(0, 'to', 3)): " + str(LogicArray('1100', Range(0, 'to', 3)).integer))

# note ordering
la = LogicArray('1100', Range(0, 'to', 3))
print("la[0]: " + str(la[0]))

# note ordering
la = LogicArray('1100', Range(3, 'downto', 0))
print("la[0]: " + str(la[0]))

# others to know

str(Logic("Z"))
bool(Logic(0))
int(Logic(1))
Bit(Logic("1"))
Bit('1')
```