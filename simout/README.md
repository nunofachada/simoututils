## Analysis of PPHPC simulation output

### File format

TSV file (tab-separated values), one column per output, one row per
iteration. Outputs in the following order: 

1. Sheep population
2. Wolves population
3. Quantity of available grass
4. Mean sheep energy
5. Mean wolves energy
6. Mean value of the countdown parameter in all cells.

**Example (first 10 lines):**

```
6400	3200	80075	4.509375	20.6634375	2.74455625
5696	3244	85138	5.953476123595506	20.11189889025894	2.433275
5455	3331	90629	6.927956003666361	19.165115580906633	2.123325
5337	3418	96563	7.538504777965149	18.065535400819194	1.81894375
5247	3461	102366	8.146178768820278	17.246460560531638	1.55265
5226	3477	108222	8.66934557979334	16.597354040839804	1.325125
5191	3486	114093	9.277017915623194	15.99885255306942	1.1388875
5206	3500	119900	9.827314636957357	15.338857142857142	0.99003125
5212	3515	125627	10.427091327705295	14.636130867709815	0.88034375
5241	3465	131158	10.964892196145774	14.225396825396825	0.807075
```
### Octave compatibility

All these utilities work in GNU Octave.

### Utilities

#### Generic utilities

TO DO

#### PPHPC-specific utilities

* [pp_plot](pp_plot.m) - Plot PPHPC simulation output

#### Helper functions

* [ci_t](ci_t.m) - Obtain a t-confidence interval.

* [ci_willink](ci_willink.m) - Obtain a Willink confidence interval (accounts 
for skewness).

* [hist_edges](hist_edges.m) - Finds the edges for an histogram (helper 
function used by other functions).

* [ltxp](ltxp.m) - Formats a p-value for LaTeX, value less than `minpv` are 
formatted to `< minpv` (requires LaTeX [siunitx] package).

* [ltxpe](ltxpe.m) - Formats a p-value for LaTeX, using exponents for very low 
p-values and underlining (double-underlining) values below 0.05 (0.01). Requires
[siunitx] and [ulem] LaTeX packages.

* [ltxr](ltxr.m) - Formats a real value for LaTeX (mainly a helper function used
by other functions, requires LaTeX [siunitx] package)

### Examples

#### Distributional output analysis

To do.

#### Statistical comparison of multiple implementations

To do.

[siunitx]: https://www.ctan.org/pkg/siunitx
[ulem]: https://www.ctan.org/pkg/ulem
