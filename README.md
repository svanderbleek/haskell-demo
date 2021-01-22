# VWAP of matches

Take matches csv file and output VWAP grouped by symbol to stdout

## Data

Input is a CSV file with the following format and no header

```
Maker(string),Taker(string),Symbol(string),Side(string),Price(int64),Quantity(uint32)
```

## Formula

Volume-weighted average price (VWAP)

```
Volume = Sum(Quantity)
VWAP = Sum(Price * Quantity) / Volume
```

## Output

JSON Object mapping Symbol to VWAP Object.

```
{Symbol: {"vwap": VWAP, "volume": Volume}}
```

## Run

Csv file assumed to not have matches with zero volume, missing fields, or strings that break CSV encoding. The app follows a fail fast approach to any invalid input states.

```
stack setup
stack build
stack exec vwap-exe matches.csv

```

The implementation is O(n) for matches length thanks to O(1) update to result map and O(1) calculation step. Space grows O(m) where there are m <= n distinct symbols.

Output does not force decimal in JSON float, this could be done with additional work if needed.

## Test

Tests cover minimal instances to demonstrate symbol grouping and VWAP calculation. QuickCheck could be used to test correctness but would require implementation of VWAP calculation over generated instances which is circular, since we aren't interested in field validation cases there is no value added.

```
stack test
```

## Distribute

To create .tar.gz

```
stack sdist
```
