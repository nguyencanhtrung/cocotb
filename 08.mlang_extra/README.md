## 1. Mixed language simulation (from official cocotb repo)

The directory `cocotb/08.mlang_extra/` contains two toplevel HDL files, one in VHDL, one in SystemVerilog, that each instantiate an `endian_swapper` entity in SystemVerilog and VHDL in parallel and chains them together so that the endianness is swapped twice.

Thus, we end up with SystemVerilog+VHDL instantiated in VHDL and SystemVerilog+VHDL instantiated in SystemVerilog.

The cocotb testbench pulls the reset on both instances and checks that they behave the same.

## 2. Hierarchy

```
.
├── hdl
│   ├── endian_swapper.sv
│   ├── endian_swapper.vhdl
│   ├── toplevel.sv
│   └── toplevel.vhdl
├── tests
│   ├── Makefile
│   └── test_mixed_language.py
└── README.md
```

## 3. Prerequisite

* Questasim or Modelsim 
* Icarus verilog does not support mixed language simulation

```
ifneq ($(filter $(SIM),ius xcelium),)
    SIM_ARGS += -v93
endif

ifneq ($(filter $(SIM),questa modelsim),)
    SIM_ARGS += -t 1ps
endif
```

## 4. Endian swapper implementation

The vhdl implementation is exactly the same as system verilog implementation. The following section describes the VHDL implementation.

### Interfaces

* `stream_in` : Avalon Stream (readyLatency = 0)
* `stream_out` : Avalon Stream (readyLatency = 0)
* `csr` : Avalon MM (fixed readLatency = 1)

Avalon Stream signals

```
*_data
*_empty
*_valid
*_startofpacket
*_endofpacket
*_ready
```

Avalon MM signals

```
csr_address
csr_readdata
csr_readdatavalid
csr_read
csr_write
csr_waitrequest
csr_writedata
```

```
-- Exposes 2 32-bit registers via the Avalon-MM interface
--    Address 0:  bit     0  [R/W] byteswap enable
--                bits 31-1: [N/A] reserved
--    Adress  1:  bits 31-0: [RO]  packet count
```

### a. Avalon stream

`flush_pipe` : flushing data in pipe is enable when reaching the end of packet. Normally flushing is enable for one extra cycle compared stream_in.

* 0 = disable flushing
* 1 = enable flushing

```
    if (flush_pipe = '1' and stream_out_ready = '1') then
        flush_pipe <= stream_in_endofpacket and stream_in_valid and stream_out_ready;
    elsif (flush_pipe = '0') then
        flush_pipe <= stream_in_endofpacket and stream_in_valid and stream_out_ready;
    end if;
```

This flag is used to drive `stream_out_valid`

```
stream_out_valid        <= '1' when (stream_in_valid = '1' and stream_out_endofpacket_int = '0') or flush_pipe = '1' else '0';
```

Others signal of Avalon stream interface

```
process (clk, reset_n) begin
    if (reset_n = '0') then
        in_packet       <= '0';
        packet_count    <= to_unsigned(0, 32);
    elsif rising_edge(clk) then

        if (stream_out_ready = '1' and stream_in_valid = '1') then
            stream_out_empty            <= stream_in_empty;
            stream_out_startofpacket    <= stream_in_startofpacket;
            stream_out_endofpacket_int  <= stream_in_endofpacket;

            if (byteswapping = '0') then
                stream_out_data      <= stream_in_data;
            else
                stream_out_data      <= byteswap(stream_in_data);
            end if;

            if (stream_in_startofpacket = '1' and stream_in_valid = '1') then
                packet_count <= packet_count + 1;
                in_packet    <= '1';
            end if;

            if (stream_in_endofpacket = '1' and stream_in_valid = '1') then
                in_packet    <= '0';
            end if;
        end if;
    end if;
end process;


stream_in_ready         <= stream_out_ready;
stream_out_endofpacket  <= stream_out_endofpacket_int;
```

`in_packet` flag

* 1 = packet flow is occuring 
* 0 = no flow occurs

### b. Avalon-MM (csr_* interface)

```
-- Hold off CSR accesses during packet transfers to prevent changing of endian configuration mid-packet
csr_waitrequest_int     <= '1' when reset_n = '0' or in_packet = '1' or (stream_in_startofpacket = '1' and stream_in_valid = '1') or flush_pipe = '1' else '0';
csr_waitrequest         <= csr_waitrequest_int;

process (clk, reset_n) begin
    if (reset_n = '0') then
        byteswapping      <= '0';
        csr_readdatavalid <= '0';
    elsif rising_edge(clk) then

        if (csr_read = '1') then
            csr_readdatavalid <= not csr_waitrequest_int;

            case csr_address is
                when "00"       => csr_readdata <= (31 downto 1 => '0') & byteswapping;
                when "01"       => csr_readdata <= std_ulogic_vector(packet_count);
                when others     => csr_readdata <= (31 downto 0 => 'X');
            end case;

        elsif (csr_write = '1' and csr_waitrequest_int = '0') then
            case csr_address is
                when "00"       => byteswapping <= csr_writedata(0);
                when others     => null;
            end case;
        end if;
    end if;
end process;
```

## 5. Top level

The top level implementation includes 2 modules

* VHDL implementation of endian swapper
* System verilog implementation of endian swapper

Two modules are connected in chain and are fed same configuration via `csr_*` interface. Reading via `csr` will get the information from SystemVerilog module (just make the implementation simple).

There are 2 toplevel which are examined. One is in VHDL and the other is in SystemVerilog. To examine VHDL toplevel just need to change the Makefile

```
# Override this variable to use a VHDL toplevel instead of SystemVerilog
TOPLEVEL_LANG ?= vhdl
```

or SystemVerilog toplevel

```
# Override this variable to use a VHDL toplevel instead of SystemVerilog
TOPLEVEL_LANG ?= verilog
```

## 6. Testbench `test_mixed_language.py`

### a. Accessing component in mixed language simulation

We are going to check the ability of accessing sub-module signals.

```
verilog = dut.i_swapper_sv
verilog.reset_n.value = 1
```

`dut` is considered as toplevel module. `dut.i_swapper_sv` is accessing the SystemVerilog module `i_swapper_sv`. 

Now, we want to drive a signal of this module, in this example `reset_n`.

Or even, we can accessing an object of a module other than a port as the following example:

```
verilog.flush_pipe.value
```

It accesses the flag `flush_pipe` of the design.


<strong>One important note</strong>

When using Modelsim/Questasim and a VHDL toplevel file, it is failed to access signal. For example,

```
#    100.00ns INFO     cocotb.regression                  mixed_language_accessing_test failed
#                                                         Traceback (most recent call last):
#                                                           File "/home/tesla/workspace/05.Soc/02.cocotb/08.mlang_extra/tests/test_mixed_language.py", line 31, in mixed_language_accessing_test
#                                                             verilog.reset_n.value = 1
#                                                           File "/home/tesla/.local/lib/python3.8/site-packages/cocotb/handle.py", line 370, in __getattr__
#                                                             raise AttributeError(f"{self._name} contains no object named {name}")
#                                                         AttributeError: i_swapper_sv contains no object named reset_n
```

It signals line `verilog.reset_n.value = 1` causing failure. The reason is SV modules are not discovered automatically in this case. A workaround is insearting this line of code before accessing SV modules.

```
verilog._discover_all()
```

while `verilog = dut.i_swapper_sv`

### b. Functional testing



## 7. Makefile


## 8. How to run simulation

```
> cd ./tests
> make SIM=questa
```



