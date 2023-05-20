# Syntax
#   BinaryValue(value=None, n_bits=None, bigEndian=None, binaryRepresentation=None)
#
# Methods
#   BinaryValue.integer is an integer
#   BinaryValue.is_resolvable is unknown or not (X,Z,U are considered unresolvable or unknown): true = resolvable | false = unresolvable
#   BinaryValue.signed_integer is a signed integer
#   BinaryValue.binstr is a string of “01xXzZ”
#   BinaryValue.buff is a binary buffer of bytes
#   BinaryValue.n_bits is number of bits of binary value
#   BinaryValue.value is an integer deprecated
#   BinaryValue.get_value is an integer (deprecated)

# Get familiar with BinaryValue
from cocotb.binary import BinaryRepresentation, BinaryValue

bv = BinaryValue(10, 8, True, BinaryRepresentation.TWOS_COMPLEMENT)
print("===============================================================")
print("BinaryValue(10, 8, True, BinaryRepresentation.TWOS_COMPLEMENT)")
print("bv.get_value(): " + str(bv.get_value()))
print("bv.integer: " + str(bv.integer))
print("===============================================================")

print()


bv = BinaryValue('XzZx0100', 8, True, BinaryRepresentation.TWOS_COMPLEMENT)
print("===============================================================")
print("BinaryValue('XzZx0100', 8, True, BinaryRepresentation.TWOS_COMPLEMENT)")
print("bv.is_resolvable: " + str(bv.is_resolvable))
print("bv.binstr: " + str(bv.binstr))
print("===============================================================")

print()


bv = BinaryValue('10000000', 8, True, BinaryRepresentation.TWOS_COMPLEMENT)
print("===============================================================")
print("BinaryValue('10000000', 8, True, BinaryRepresentation.TWOS_COMPLEMENT)")
print("bv.get_value_signed(): " + str(bv.get_value_signed()))
print("bv.signed_integer: " + str(bv.signed_integer))
print("===============================================================")

print()

bv = BinaryValue(n_bits=10, bigEndian=False,
                 binaryRepresentation=BinaryRepresentation.TWOS_COMPLEMENT)
bv.integer = -128
print("===============================================================")
print("bv = BinaryValue(n_bits=10, bigEndian=False, binaryRepresentation=BinaryRepresentation.TWOS_COMPLEMENT)")
print("bv.integer = -128")
print("bv.get_value_signed: " + str(bv.signed_integer))
print("bv.get_value_signed: " + str(bv.n_bits))
print("===============================================================")
