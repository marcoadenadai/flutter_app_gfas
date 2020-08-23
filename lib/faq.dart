import 'dart:convert';
import 'dart:io';

import 'package:GFAS/constants.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class FAQ extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('FAQ'),
        ),
        body: ListView.builder(
          itemBuilder: (BuildContext context, int index) =>
              EntryItem(data[index]),
          itemCount: data.length,
        ),
      ),
    );
  }
}

// One entry in the multilevel list displayed by this app.
class Entry {
  Entry(this.title, [this.children = const <Entry>[]]);

  final String title;
  final List<Entry> children;
}

// The entire multilevel list displayed by this app.
final List<Entry> data = <Entry>[
  Entry(
    'O que é GFAS',
    <Entry>[
      Entry(
        'Global Fire Alarm System',
      ),
    ],
  ),
  Entry(
    'Os beneficios do GFAS',
    <Entry>[
      Entry(
          'O sistema visa monitorar continuamente áreas remotas propensas a incêndios florestais. Além disso, também busca detectar antecipadamente e alertar incidentes de incêndio, bem como a comunicação de dados críticos. '
      ),
    ],
  ),
  Entry(
    'Como funciona o GFAS',
    <Entry>[
      Entry(
        'O sistema é usado para alarme de incêndio, gerenciamento de equipamentos, além de selecionar a melhor rota de resgate utilizando GIS para pesquisa de base e projetar o módulo de função do sistema com CRT para exibição gráfica. O sistema oferece um meio de avaliar, analisar, planejar e implementar pesquisas ambientais. A tecnologia é usada como ferramenta para entender melhor as mudanças climáticas e ambientais. O sensoriamento remoto viabiliza a capacidade de monitorar recursos e mudanças na Terra e o GIS fornece as ferramentas para integrar e analisar o grande volumede geoinformação. A detecção inteligente de incêndio e o sistema de alerta estabelecido por uma região de reconhecimento correspondente a um pixel e o reconhecimento da distorção causada por pequenas chamas. Este artigo oferece uma visão geral de modelos de dados espaço-temporais relevantes e a análise das tendências e desenvolvimentos em T-GIS.'
      ),
    ],
  ),
  Entry(
    'Ferramentas do GFAS',
    <Entry>[
      Entry('- Alertas de Focos de Incendio'),
      Entry('- Chamar Corpo de Bombeiros'),
      Entry('- Monitoramento da Area registrada'),
      Entry('- Previsao de possiveis Incendios na Area'),
    ],
  ),
];

// Displays one Entry. If the entry has children then it's displayed
// with an ExpansionTile.
class EntryItem extends StatelessWidget {
  const EntryItem(this.entry);

  final Entry entry;

  Widget _buildTiles(Entry root) {
    if (root.children.isEmpty) return ListTile(title: Text(root.title));
    return ExpansionTile(
      key: PageStorageKey<Entry>(root),
      title: Text(root.title),
      children: root.children.map(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}