---
title: "Data mining - Sprawozdanie"
author: "Patryk Nizio"
date: "15 grudnia 2018"
output:
  html_document:
    css: style.css
    toc: true
    toc_depth: 3
    toc_float:
      collapsed: false
      smooth_scroll: true
    highlight: tango
    keep_md: true
    code_folding: hide


---






## 1. Zrozumienie uwarunkowań biznesowych

### 1.1 Biodiesel

Biodiesel jest paliwem odnawialnym wytwarzanym głównie w drodze transestryfikacji olejów i tłuszczów, które mogą być wykorzystywane jako paliwo transportowe, rozpuszczalnik i do wytwarzania energii, co może zmniejszyć emisje CO2, SO2, CO i HC w porównaniu z paliwami kopalnymi.

W przemyśle stosuje się również mieszanki paliwowe z olejem napędowym w celu otrzymania paliwa zapewniającego lepsze warunki pracy silnika. 

Biopaliwa stwarzają ogromne możliwości dla rozwoju gospodarki oraz aktywizację terenów wiejskich i zagospodarowanie nieużytków rolnych. Pozwalają na częściowe uniezależnienie energetyczne kraju od dostaw ropy oraz zmniejszenie zależności cen paliwa od zmian ceny ropy naftowej i kursów walut. 

Poza argumentami gospodarczymi możemy dostrzec pozytywny wpływ na środowisko.
Część wyemitowanego w trakcie spalania dwutlenku węgla została wcześniej wchłonięta przez rośliny, a w przypadku ON pochodzi on z ropy naftowej, w związku z tym wprowadza się mniejsze ilości dodatkowego CO2 do atmosfery.
Spalanie biopaliw nie zanieczyszcza powietrza związkami siarki, choć tutaj warto wspomnieć że powoduje emisję o około 20% więcej tlenków azotu.

Obecnie paliwo to zyskuje na popularności, w krajach Unii Europejskiej produkcja tego biopaliwa wzrasta o 20% rocznie.
Postęp technologiczny w tej dziedzinie obniża koszty produkcji przez co cena biodiesla jest porównywalna do ceny zwykłego diesla. 
Polityka proekologiczna prowadzona przez wiele państw promuje wykorzystanie odnawialnych źródeł energii, biopaliw i hybryd.
Dyrektywa europejska z 2003 roku narzuca państwom członkowskim UE wprowadzenie podatkowej promocji biopaliw. Wdrażanie jej postanowień do prawa w Polsce to m.in. zwolnienia od podatku akcyzowego .

### 1.2 Transestryfikacja nadkrytyczna

Jedną z alternatywnych metod produkcji biodiesla jest transestryfikacja nadkrytyczna.
Metoda transestryfikacji ta jest wolna od katalizatora i wykorzystuje nadkrytyczny metanol w wysokich temperaturach i ciśnieniach w procesie ciągłym. W stanie nadkrytycznym olej i metanol są w jednej fazie, a reakcja zachodzi spontanicznie i szybko. Proces może tolerować wodę w surowcu, wolne kwasy tłuszczowe są przekształcane w estry metylowe zamiast mydła, więc można stosować wiele różnych surowców. Eliminowany jest również etap usuwania katalizatora. Wymagane są wysokie temperatury i ciśnienia, ale koszty energii związane z produkcją są podobne lub mniejsze niż katalitycznych metod produkcyjnych.

### 1.3 Cel analizy

Celem poniższej analizy jest stworzenie modelu procesu krytycznej transestryfikacji który można  wykorzystać do symulacji i optymalizacji procesów produkcji biodiesla.
Analiza podzielona jest zgodnie z metodyką CRISP-DM.



## 2. Zrozumienie danych

Otrzymane dane to wyniki pomiaru w procesie transestryfikacji.
Doświadczenia z transestryfikacją oleju rzepakowego w alkoholach nadkrytycznych (metanol, etanol i 1-propanol) prowadzono w reaktorze wsadowym w różnych temperaturach reakcji (250-350 ° C), ciśnieniu roboczym (8-12 MPa), czasie reakcji i stałym stosuneku molowym alkoholu do oleju wynoszącym 42:1. 

W pliku z wynikami doświadczenia zarejestrowano 105 pomiarów o ponizszych parametrach: 

* run_id - numer pomiaru

* b_temp - temperatura w czasie reakcji

* b_press - ciśnienie w czas reakcji

* b_time - czas reakcji

* meth_pct - stężenie metanolu

* meth_ec - konsumpcja energii dla metanolu 

* eth_pct - stężenie etanolu

* eth_ec - konsumpcja energii dla etanolu

* prop1_pct - stężenie propanol-1

* prop1_ec - konsumpcja energii dla propanol-1




## 3. Przygotowanie i analiza danych
Dane mają charakter tabelaryczny. Przypadki nie są z sobą powiązane, zmieniają się natomiast parametry pomiarów.
Dane nie wymagały czyszczenia, nie wykryto anomali oraz dziur. 



### 3.1 Statystyki opisowe


```r
summary(df[2:10])
```

```
##   temperature       pressure           time           meth_pct    
##  Min.   :250.0   Min.   : 8.000   Min.   :  7.00   Min.   :13.80  
##  1st Qu.:250.0   1st Qu.: 8.000   1st Qu.: 20.00   1st Qu.:46.20  
##  Median :300.0   Median :10.000   Median : 35.00   Median :55.00  
##  Mean   :288.6   Mean   : 9.657   Mean   : 40.27   Mean   :59.44  
##  3rd Qu.:300.0   3rd Qu.:12.000   3rd Qu.: 55.00   3rd Qu.:78.80  
##  Max.   :350.0   Max.   :12.000   Max.   :100.00   Max.   :93.00  
##     meth_ec         eth_pct          eth_ec        prop1_pct   
##  Min.   :0.612   Min.   : 9.80   Min.   :0.682   Min.   : 8.3  
##  1st Qu.:0.801   1st Qu.:39.80   1st Qu.:0.971   1st Qu.:32.7  
##  Median :1.014   Median :51.20   Median :1.144   Median :47.4  
##  Mean   :1.064   Mean   :52.63   Mean   :1.264   Mean   :47.4  
##  3rd Qu.:1.220   3rd Qu.:66.30   3rd Qu.:1.445   3rd Qu.:61.3  
##  Max.   :2.816   Max.   :91.90   Max.   :4.068   Max.   :91.1  
##     prop1_ec    
##  Min.   :0.723  
##  1st Qu.:1.072  
##  Median :1.209  
##  Mean   :1.449  
##  3rd Qu.:1.696  
##  Max.   :4.803
```

### 3.2 Histogramy

#### Wpływ czasu na reakcje {.tabset .tabset-fade .tabset-pills}

##### Ogólny

```r
boxplot((meth_ec + eth_ec + prop1_ec)/3 ~ temperature, data = df, col = "lightgray", varwidth = TRUE, 
        main = "Konsumpcja energii a temperatura (średnia)",
        ylab = "Konsumpcja energii (kW h/kg)",xlab = "Temperatura w °C")
```

![](README_files/figure-html/unnamed-chunk-3-1.png)<!-- -->

##### Metanol

```r
boxplot(meth_ec ~ temperature, data = df, col = "lightgray", varwidth = TRUE, 
        main = "Konsumpcja energii a temperatura dla metanolu",
        ylab = "Konsumpcja energii (kW h/kg)",xlab = "Temperatura w °C")
```

![](README_files/figure-html/unnamed-chunk-4-1.png)<!-- -->

##### Etanol

```r
boxplot(eth_ec ~ temperature, data = df, col = "lightgray", varwidth = TRUE, 
        main = "Konsumpcja energii a temperatura dla etanolu",
        ylab = "Konsumpcja energii (kW h/kg)",xlab = "Temperatura w °C")
```

![](README_files/figure-html/unnamed-chunk-5-1.png)<!-- -->

##### Propanol

```r
boxplot(prop1_ec ~ temperature, data = df, col = "lightgray", varwidth = TRUE, 
        main = "Konsumpcja energii a temperatura dla propanolu",
        ylab = "Konsumpcja energii (kW h/kg)",xlab = "Temperatura w °C")
```

![](README_files/figure-html/unnamed-chunk-6-1.png)<!-- -->

####
Na podstawie histogramu konsumpcji energi do temperatury możemy wnioskować że im wyższa temperatura tym reakcja potrzebuje mniej energii. Reakcja transestryfikacji jest bardziej wydajna w wyższych temperaturach.

#### Wpływ czasu na reakcje {.tabset .tabset-fade .tabset-pills}

##### Ogólny

```r
boxplot( (meth_ec + eth_ec + prop1_ec)/3 ~ time, data = df, col = "lightgray", varwidth = TRUE, 
        main = "Konsumpcja energii a czas",
        ylab = "Konsumpcja energii (kW h/kg)",xlab = "Czas w minutach")
```

![](README_files/figure-html/unnamed-chunk-7-1.png)<!-- -->

##### Metanol

```r
boxplot(meth_ec ~ time, data = df, col = "lightgray", varwidth = TRUE, 
        main = "Konsumpcja energii a czas dla metanolu",
        ylab = "Konsumpcja energii (kW h/kg)",xlab = "Czas w minutach")
```

![](README_files/figure-html/unnamed-chunk-8-1.png)<!-- -->

##### Etanol

```r
boxplot(eth_ec  ~ time, data = df, col = "lightgray", varwidth = TRUE, 
        main = "Konsumpcja energii a czas dla etanolu",
        ylab = "Konsumpcja energii (kW h/kg)",xlab = "Czas w minutach")
```

![](README_files/figure-html/unnamed-chunk-9-1.png)<!-- -->

##### Propanol

```r
boxplot(prop1_ec ~ time, data = df, col = "lightgray", varwidth = TRUE, 
        main = "Konsumpcja energii a czas dla propanolu",
        ylab = "Konsumpcja energii (kW h/kg)",xlab = "Czas w minutach")
```

![](README_files/figure-html/unnamed-chunk-10-1.png)<!-- -->

#### 
Możemy zauważyć że początkowy etap zużywa najwięcej energi jednak z czasem jej zużycie spada (okolice 15 - 25 minut) a następnie znóW rośnie. Możemy wysnuć hipoteze ze optymalny czas reakcji powinien wynosić 15 - 25 minut.  


#### Wpływ ciśnienia na reakcje {.tabset .tabset-fade .tabset-pills}

##### Ogólny

```r
boxplot( (meth_ec + eth_ec + prop1_ec)/3 ~ pressure, data = df, col = "lightgray", varwidth = TRUE, 
        main = "Konsumpcja energii a ciśnienie (średnia)",
        ylab = "Konsumpcja energii (kW h/kg)",xlab = "Ciśnienie w MPa")
```

![](README_files/figure-html/unnamed-chunk-11-1.png)<!-- -->

##### Metanol

```r
boxplot(meth_ec ~ pressure, data = df, col = "lightgray", varwidth = TRUE, 
        main = "Konsumpcja energii a ciśnienie dla metanolu",
        ylab = "Konsumpcja energii (kW h/kg)",xlab = "Ciśnienie w MPa")
```

![](README_files/figure-html/unnamed-chunk-12-1.png)<!-- -->

##### Etanol

```r
boxplot(eth_ec  ~ pressure, data = df, col = "lightgray", varwidth = TRUE, 
        main = "Konsumpcja energii a ciśnienie dla etanolu",
        ylab = "Konsumpcja energii (kW h/kg)",xlab = "Ciśnienie w MPa")
```

![](README_files/figure-html/unnamed-chunk-13-1.png)<!-- -->

##### Propanol

```r
boxplot(prop1_ec ~ pressure, data = df, col = "lightgray", varwidth = TRUE, 
        main = "Konsumpcja energii a ciśnienie dla propanolu",
        ylab = "Konsumpcja energii (kW h/kg)",xlab = "Ciśnienie w MPa")
```

![](README_files/figure-html/unnamed-chunk-14-1.png)<!-- -->

#### 
Ciśnienie podobnie jak czas nie wpływa znacząco na reakcje. Możemy zauważyć jednak ze wraz ze wzrostem ciśnienia maleje konsumpcja energii. Dla reakcji w wysokich temperaturach rola ciśnienia może rosnąć. 
 
 
### 3.3 Wykresy punktowe

```r
plot(c(meth_ec,eth_ec,prop1_ec), c(meth_pct,eth_pct,prop1_pct), pch = 15, col = c("#9055A2" ,"#011638", "#D499B9"), main = "Stężenie alkoholu do konsumpcji energi w procesie transestryfikacji", xlab = "Konsumpcja energii (kW h/kg)", ylab = "Stężenie procentowe alkoholu %")
```

![](README_files/figure-html/unnamed-chunk-15-1.png)<!-- -->
 


## 4. Modelowanie



## Wnioski

Temperatura miała największy wpływ na wydajność, a następnie czas reakcji i ciśnienie. Przy zwiększonej masie cząsteczkowej alkoholi, względne znaczenie temperatury dla wyjaśnienia wydajności spadło, a względne znaczenie czasu i ciśnienia wzrosło. Ocena ekonomiczna wykazała, że transestryfikacja w metanolu nadkrytycznym ma najniższe bezpośrednie koszty materiałowe i energetyczne. Wydajność ma decydujący wpływ na ekonomikę procesu. Bezpośrednie koszty maleją wraz ze wzrostem wydajności biodiesla. Nawet przy bardzo niskich cenach surowca naftowego najniższy koszt osiąga się z najwyższą wydajnością.
 



```r
summary(cars)
```

```
##      speed           dist       
##  Min.   : 4.0   Min.   :  2.00  
##  1st Qu.:12.0   1st Qu.: 26.00  
##  Median :15.0   Median : 36.00  
##  Mean   :15.4   Mean   : 42.98  
##  3rd Qu.:19.0   3rd Qu.: 56.00  
##  Max.   :25.0   Max.   :120.00
```

## Including Plots

You can also embed plots, for example:

![](README_files/figure-html/pressure-1.png)<!-- -->

## Przypisy
1. Andrzej Roszkowski, Biodiesel w UE i Polsce obecne uwarunkowania i perspektywy, „Problemy inżynierii rolniczej”, 77 (3), Wydawnictwo Instytutu Technologiczno-Przyrodniczego, 2012, s. 65-67, ISSN 1231-0093

2. https://podatki.gazetaprawna.pl/artykuly/92098,biopaliwa-zgodnie-z-rozporzadzeniem-sa-objete-ulga-w-podatku-akcyzowym.html 

3. Sujeeta Karki, Nawaraj Sanjel, Jeeban Poudel, Ja Hyung Choi and Sea Cheon Oh, Supercritical Transesterification of Waste Vegetable Oil: Characteristic Comparison of Ethanol and Methanol as Solvents, 2017

4. Somkiat Ngamprasertsith and Ruengwit Sawangkeaw, Transesterification in Supercritical Conditions 

Note that the `echo = FALSE` parameter was added to the code chunk to prevent printing of the R code that generated the plot.
