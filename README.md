# E-Commerce Sales & Logistics Analytics (Olist) 📊

## Cel projektu
Analiza wyników sprzedażowych brazylijskiego e-commerce w celu identyfikacji kluczowych rynków, trendów sezonowych oraz rentowności logistyki. Projekt demonstruje proces przetwarzania danych: od surowych tabel transakcyjnych, przez transformacje w SQL, po zoptymalizowany dashboard zarządczy.

## Stack technologiczny
* **Baza danych:** PostgreSQL (główny silnik obliczeniowy, złączenia tabel, agregacje)
* **Wizualizacja:** Power BI (karty KPI, analiza trendów, relacje geograficzne)
* **Środowisko:** DBeaver 

## Wnioski z projektu
1. **Dominacja São Paulo i logistyka:** Stan SP odpowiada za wielką część przychodów (ponad 5 mln R$), co bezpośrednio koreluje z najniższym w kraju średnim kosztem dostawy (~15 R$). W stanach o kosztach logistyki przekraczających 30 R$ widać drastyczny spadek przychodów.
2. **Kluczowe kategorie:** Zdecydowanym liderem napędzającym marżę jest "Zdrowie i Uroda" (1.23 mln R$), marginalnie wyprzedzając "Zegarki i Prezenty".
3. **Sezonowość:** Wykres trendu obnaża potężny pik sprzedażowy w listopadzie 2017 roku ([artykuł o Black Friday w Brazylii](https://www.independent.co.uk/news/world/black-friday-2017-brazil-shoppers-discount-sales-brazil-south-africa-a8073651.html)), który ustawił nowy, wyższy próg dla kolejnych miesięcy.

## Architektura i optymalizacja
Zamiast obciążać model danych w Power BI setkami tysięcy wierszy z tabel faktów i wymiarów, cała ciężka logika biznesowa została zepchnięta do warstwy bazy danych. Wszelkie kalkulacje, filtrowanie oraz mapowanie słowników (pełne nazwy stanów i polskie tłumaczenia kategorii) wykonuje PostgreSQL. Power BI pobiera gotowe do wyświetlenia, zagregowane paczki danych.

## Dashboard
<img width="4100" height="2350" alt="analiza-sprzedazy-kraggle-brazylian-1" src="https://github.com/user-attachments/assets/a53b384e-63c6-4f03-adeb-e8c4cafb6894" />


