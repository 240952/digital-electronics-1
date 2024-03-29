# Lab 2: Elena Melicharová

### 2-bit comparator

1. Karnaugh maps for other two functions of 2-bit comparator:

   Greater than:

   ![vetsi](https://user-images.githubusercontent.com/124675731/219973053-a584fd5a-2f5f-47bd-a981-3b88e9427119.png)


   Less than:

   ![mensi](https://user-images.githubusercontent.com/124675731/219973084-8aa4b41b-e2df-498b-980a-ffc240b4a479.png)


2. Mark the largest possible implicants in the K-map and according to them, write the equations of simplified SoP (Sum of the Products) form of the "greater than" function and simplified PoS (Product of the Sums) form of the "less than" function.

   ![rovnice](https://user-images.githubusercontent.com/124675731/219974548-209e3ebc-8b8d-47c1-aee5-588b42fd115c.png)


### 4-bit comparator

1. Listing of VHDL stimulus process from testbench file (`testbench.vhd`) with at least one assert (use BCD codes of your student ID digits as input combinations). Always use syntax highlighting, meaningful comments, and follow VHDL guidelines:

   Last two digits of my student ID: **xxxx52**

```vhdl
    p_stimulus : process
    begin
        -- Report a note at the beginning of stimulus process
        report "Stimulus process started" severity note;

        -- First test case
        s_b <= "0101"; 
        s_a <= "0010";      
        wait for 100 ns;
        -- Expected output
        assert ((s_B_greater_A = '0') and
                (s_B_equals_A  = '1') and
                (s_B_less_A    = '0'))
        -- If false, then report an error
        report "Input combination 0101, 0010 FAILED" severity error;

        -- Report a note at the end of stimulus process
        report "Stimulus process finished" severity note;
        wait;
    end process p_stimulus;
```

2. Link to your public EDA Playground example:

   [https://www.edaplayground.com/...](https://www.edaplayground.com/x/gzEC)
