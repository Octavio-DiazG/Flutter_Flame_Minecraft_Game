import 'dart:developer';
import 'dart:math';

import 'package:fast_noise/fast_noise.dart';
import 'package:minecraft2d_game/resources/blocks.dart';
import 'package:minecraft2d_game/utils/constant.dart';
import 'package:minecraft2d_game/utils/game_methods.dart';

class ChunkGenerationMethods{


  static ChunkGenerationMethods get instance{
    return ChunkGenerationMethods();
  }

  List<List<Blocks?>> generateNullChunk(){
    return List.generate(
      chunkHeight, (index) => List.generate(chunkWidth, (index) => null)
    );
  }

  List<List<Blocks?>> generateChunk(){
    List<List<Blocks?>> chunk = generateNullChunk();

    List<List<double>> rawNoise = noise2(
      chunkWidth, 
      1, 
      noiseType: NoiseType.Perlin, 
      frequency: 0.05,
      seed: 7686987,
    );

    //log(getYValuesFromRawNoise(rawNoise).toString());
    List<int> yValues = getYValuesFromRawNoise(rawNoise);

    chunk = generatePrimarySoil(chunk, yValues, Blocks.grass);

    chunk = generateSecondarySoil(chunk, yValues, Blocks.dirt);

    chunk = generateStone(chunk);

    return chunk;
  }

  List<List<Blocks?>> generatePrimarySoil(List<List<Blocks?>> chunk, List<int> yValues, Blocks block){
    yValues.asMap().forEach((int index, int value) {
      chunk[value][index] = block;
    });
    return chunk;
  }

  List<List<Blocks?>> generateSecondarySoil(List<List<Blocks?>> chunk, List<int> yValues, Blocks block){
    yValues.asMap().forEach((int index, int value) {
      for (int i = value + 1; i <= GameMethods.instance.maxSecondarySoilExtent; i++) {
        chunk[i][index] = block;
      }
    });

    return chunk;
  }

  List<List<Blocks?>> generateStone(List<List<Blocks?>> chunk){

    for (int index = 0; index < chunkWidth; index++) {
      for (int i = GameMethods.instance.maxSecondarySoilExtent + 1; i < chunk.length; i++) {
        chunk[i][index] = Blocks.stone;
      }
    }
    int x1 = Random().nextInt(chunkWidth ~/ 2); // ~ is the same to say .toInt()
    int x2 = x1 + Random().nextInt(chunkWidth ~/ 2);

    chunk[GameMethods.instance.maxSecondarySoilExtent].fillRange(x1, x2, Blocks.stone);

    return chunk;
  }


  List<int> getYValuesFromRawNoise (List<List<double>> rawNoise){
    List<int> yValues = [];

    rawNoise.asMap().forEach((int index, List<double> value) {
      yValues.add((value[0] * 10).toInt().abs() + GameMethods.instance.freeArea);
    });

    return yValues;
  }
}

/*

 chunk = [

  [Null, null, null, null],
  [Blocks.grass, Blocks.dirt],
  [],
  [],
  [],
  [],
  [],
  [null, null, null],
  [Blocks.stone, blocks.stone],
  [],
  [],
  [],

 ]

*/