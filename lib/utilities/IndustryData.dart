import 'IndustryModel.dart';

class IndustryData {
  List<Map> getAll() => _industries;

  getBranchByIndustry(String branch) => _industries
      .map((map) => IndustryModel.fromJson(map))
      .where((item) => item.branch == branch)
      .map((item) => item.trade)
      .expand((i) => i)
      .toList();

  getBranchKeyByIndustry(String branchKey) => _industries
      .map((map) => IndustryModel.fromJson(map))
      .where((item) => item.branch == branchKey)
      .map((item) => item.branchKey)
      .toString()
      .substring(1, 2);

  List<String> getIndustryByBranchKey(String key) => _industries
      .map((map) => IndustryModel.fromJson(map))
      .where((item) => item.branchKey == key)
      .map((item) => item.branch)
      .toList();

  List<String> getIndustries() => _industries
      .map((map) => IndustryModel.fromJson(map))
      .map((item) => item.branch)
      .toList();

  List _industries = [
    {
      'branch': 'Land- und Forstwirtschaft, Fischerei',
      'key': 'A',
      'trade': [
        '01 Landwirtschaft, Jagd und damit verbundene Tätigkeiten',
        '02 Forstwirtschaft und Holzeinschlag',
        '03 Fischerei und Aquakultur',
      ]
    },
    {
      'branch': 'Verarbeitendes Gewerbe',
      'key': 'C',
      'trade': [
        '10 Herstellung von Nahrungs- und Futtermitteln',
        '11 Getränkeherstellung',
        '12 Tabakverarbeitung',
        '13 Herstellung von Textilien',
        '14 Herstellung von Bekleidung',
        '15 Herstellung von Leder, Lederwaren und Schuhen',
        '16 Herstellung von Holz-, Flecht-, Korb- und Korkwaren (ohne Möbel)',
        '17 Herstellung von Papier, Pappe und Waren daraus',
        '18 Herstellung von Druckerzeugnissen; Vervielfältigung von bespielten Ton-, Bild- und Datenträgern',
        '19 Kokerei und Mineralölverarbeitung',
        '20 Herstellung von chemischen Erzeugnissen',
        '21 Herstellung von pharmazeutischen Erzeugnissen',
        '22 Herstellung von Gummi- und Kunststoffwaren',
        '23 Herstellung von Glas und Glaswaren, Keramik, Verarbeitung von Steinen und Erden',
        '24 Metallerzeugung und -bearbeitung',
        '25 Herstellung von Metallerzeugnissen',
        '26 Herstellung von Datenverarbeitungsgeräten, elektronischen und optischen Erzeugnissen',
        '27 Herstellung von elektrischen Ausrüstungen',
        '28 Maschinenbau',
        '29 Herstellung von Kraftwagen und Kraftwagenteilen',
        '30 Sonstiger Fahrzeugbau',
        '31 Herstellung von Möbeln',
        '32 Herstellung von sonstigen Waren',
        '33 Reparatur und Installation von Maschinen und Ausrüstungen',
      ]
    },
    {
      'branch': 'Energieversorgung',
      'key': 'D',
      'trade': [
        '35 Energieversorgung',
      ]
    },
    {
      'branch':
          'Wasserversorgung; Abwasser- und Abfallentsorgung und Beseitigung von Umweltverschmutzungen',
      'key': 'E',
      'trade': [
        '36 Wasserversorgung',
        '37 Abwasserentsorgung',
        '38 Sammlung, Behandlung und Beseitigung von Abfällen; Rückgewinnung',
        '39 Beseitigung von Umweltverschmutzungen und sonstige Entsorgung',
      ]
    },
    {
      'branch': 'Baugewerbe',
      'key': 'F',
      'trade': [
        '41 Hochbau',
        '42 Tiefbau',
        '43 Vorbereitende Baustellenarbeiten, Bauinstallation und sonstiges Ausbaugewerbe',
      ]
    },
    {
      'branch': 'Handel; Instandhaltung und Reparatur von Kraftfahrzeugen',
      'key': 'G',
      'trade': [
        '45 Handel mit Kraftfahrzeugen; Instandhaltung und Reparatur von Kraftfahrzeugen',
        '46 Großhandel (ohne Handel mit Kraftfahrzeugen)',
        '47 Einzelhandel (ohne Handel mit Kraftfahrzeugen)',
      ]
    },
    {
      'branch': 'Verkehr und Lagerei',
      'key': 'H',
      'trade': [
        '49 Landverkehr und Transport in Rohrfernleitungen',
        '50 Schifffahrt',
        '51 Luftfahrt',
        '52 Lagerei sowie Erbringung von sonstigen Dienstleistungen für den Verkehr',
        '53 Post-, Kurier- und Expressdienste',
      ]
    },
    {
      'branch': 'Gastgewerbe',
      'key': 'I',
      'trade': [
        '55 Beherbergung',
        '56 Gastronomie',
      ]
    },
    {
      'branch': 'Information und Kommunikation',
      'key': 'J',
      'trade': [
        '58 Verlagswesen',
        '59 Herstellung, Verleih und Vertrieb von Filmen und Fernsehprogrammen; Kinos; Tonstudios und Verlegen von Musik',
        '60 Rundfunkveranstalter',
        '61 Telekommunikation',
        '62 Erbringung von Dienstleistungen der Informationstechnologie',
        '63 Informationsdienstleistungen',
      ]
    },
    {
      'branch': 'Erbringung von Finanz- und Versicherungsdienstleistungen',
      'key': 'K',
      'trade': [
        '64 Erbringung von Finanzdienstleistungen',
        '65 Versicherungen, Rückversicherungen und Pensionskassen (ohne Sozial-versicherung)',
        '66 Mit Finanz- und Versicherungsdienstleistungen verbundene Tätigkeiten',
      ]
    },
    {
      'branch': 'Grundstücks- und Wohnungswesen',
      'key': 'L',
      'trade': [
        '68 Grundstücks- und Wohnungswesen',
      ]
    },
    {
      'branch':
          'Erbringung von freiberuflichen, wissenschaftlichen und technischen Dienstleistungen',
      'key': 'M',
      'trade': [
        '69 Rechts- und Steuerberatung, Wirtschaftsprüfung',
        '70 Verwaltung und Führung von Unternehmen und Betrieben; Unternehmens-beratung',
        '71 Architektur- und Ingenieurbüros; technische, physikalische und chemische Untersuchung',
        '72 Forschung und Entwicklung',
        '73 Werbung und Marktforschung',
        '74 Sonstige freiberufliche, wissenschaftliche und technische Tätigkeiten',
        '75 Veterinärwesen',
      ]
    },
    {
      'branch': 'Erbringung von sonstigen wirtschaftlichen Dienstleistungen',
      'key': 'N',
      'trade': [
        '77 Vermietung von beweglichen Sachen',
        '78 Vermittlung und Überlassung von Arbeitskräften',
        '79 Reisebüros, Reiseveranstalter und Erbringung sonstiger Reservierungsdienstleistungen',
        '80 Wach- und Sicherheitsdienste sowie Detekteien',
        '81 Gebäudebetreuung; Garten- und Landschaftsbau',
        '82 Erbringung von wirtschaftlichen Dienstleistungen für Unternehmen und Privatpersonen a. n. g.',
      ]
    },
    {
      'branch': 'Gesundheits- und Sozialwesen',
      'key': 'Q',
      'trade': [
        '86 Gesundheitswesen',
        '87 Heime (ohne Erholungs- und Ferienheime)',
        '88 Sozialwesen (ohne Heime)',
      ]
    },
    {
      'branch': 'Kunst, Unterhaltung und Erholung',
      'key': 'R',
      'trade': [
        '90 Kreative, künstlerische und unterhaltende Tätigkeiten',
        '91 Bibliotheken, Archive, Museen, botanische und zoologische Gärten',
        '92 Spiel-, Wett- und Lotteriewesen',
        '93 Erbringung von Dienstleistungen des Sports, der Unterhaltung und der Erholung',
      ]
    },
    {
      'branch': 'Erbringung von sonstigen Dienstleistungen',
      'key': 'S',
      'trade': [
        '94 Interessenvertretungen sowie kirchliche und sonstige religiöse Vereinigungen (ohne Sozialwesen und Sport)',
        '95 Reparatur von Datenverarbeitungsgeräten und Gebrauchsgütern',
        '96 Erbringung von sonstigen überwiegend persönlichen Dienstleistungen',
      ]
    },
  ];
}
