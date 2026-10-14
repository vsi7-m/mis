# Maximum Independent Set on Trees (Dynamic Programming)

**Vak:** Algoritmen en Datastructuren II  
**Onderdeel:** Taak 2 - Dynamisch programmeren  
**Auteur:** Lisa Wei  
**Academiejaar:** 2024–2025 (1e zittijd)  

---

## Overzicht

Voor de implementatie van het **Maximum Independent Set (MIS)** probleem op bomen is gebruikgemaakt van de `adjacency-list` uit de `a-d`-bibliotheek. Er zijn geen bestaande bestanden binnen de bibliotheek gewijzigd.

### Waarom Adjacency-List?
* **Geheugenefficiëntie:** Een adjacency-list verbruikt significant minder geheugen dan een adjacency-matrix. Voor bomen is dit optimaal omdat niet-bestaande bogen niet worden opgeslagen.
* **Tijdcomplexiteit:** Iteraties via `for-each-edge` verlopen sneller omdat uitsluitend bestaande bogen worden doorlopen in plaats van alle mogelijke paren knopen.

### Referenties
* [Maximum Independent Set on Trees (YouTube)](https://www.youtube.com/watch?v=-LN5-GvV-bQ)

---

## Aanpak & Architectuur

Er is gekozen voor een **top-down benadering** met behulp van recursie en **memoization**. 

* **Top-down vs. Bottom-up:** Top-down is overzichtelijker en eenvoudiger te implementeren omdat een expliciete post-order traversal vermeden wordt. Hoewel een bottom-up benadering bij extreem diepe bomen stack overflows kan voorkomen en extra geheugenwinst kan opleveren, volstaat de top-down aanpak ruimschoots voor de gegeven specificaties en testgevallen.

### Memoization
* Er wordt een vector `memo` aangemaakt met een lengte gelijk aan het aantal knopen in de graaf.
* Elke positie correspondeert met een knoop en is geïnitialiseerd op `#f`.
* Bij elk recursief bezoek controleert `(vector-ref memo node)` of de MIS-waarde voor de betreffende deelboom al berekend is. 
* Zo niet, dan wordt de waarde berekend en via `(vector-set! memo node result)` opgeslagen om dubbele berekeningen te elimineren.

---

## Implementatiedetails

### Hoofdprocedure: `mist`
De recursieve procedure evalueert voor elke knoop twee complementaire keuzes:

$$\text{MIS}(\text{node}) = \max(\text{skip}, \, \text{keep})$$

1. **`skip` (Huidige knoop niet opnemen in de set):**
   * Loop door alle buren (`child`) van `node`.
   * Vermijd teruglopen in de boom door te verifiëren dat `child != parent`.
   * Bereken recursief `(mist child node)` en tel deze waarden bij elkaar op.
   * Formule: 
     $$\text{skip} = \sum_{\text{child}} \text{MIS}(\text{child})$$

2. **`keep` (Huidige knoop wel opnemen in de set):**
   * Omdat buren niet direct naast elkaar in een onafhankelijke set mogen zitten, worden de kinderen overgeslagen en worden de kleinkinderen (`grandchildren`) recursief aangeroepen.
   * Vermijd cycli door te controleren dat `grandchild != node`.
   * Bereken de recursieve MIS-waarde voor alle kleinkinderen en tel de huidige knoop ($+1$) erbij op:
     $$\text{keep} = 1 + \sum_{\text{grandchild}} \text{MIS}(\text{grandchild})$$

3. **Selectie & Opslag:**
   * Neem het maximum van `skip` en `keep`.
   * Sla het resultaat op in `memo` en retourneer de waarde.

De berekening start bij de root (`0`) zonder parent: `(mist 0 '())`.

---

## Hulpprocedures

* **`descendants` (Niet gebruikt):**  
  Oorspronkelijk ontworpen om kinderen en kleinkinderen via lijsten en `cons`-operaties te groeperen. Deze procedure is uiteindelijk weggelaten ten gunste van directe bogen-iteraties binnen de `keep`-stap; dit voorkomt onnodige lijstmanipulaties en houdt de code compacter en beter leesbaar.
