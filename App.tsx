import React from 'react';
import {
  Dimensions,
  SafeAreaView,
  ScrollView,
  StatusBar,
  StyleSheet,
  Text,
  useColorScheme,
  View,
} from 'react-native';

import {
  Colors,
  DebugInstructions,
  Header,
  LearnMoreLinks,
  ReloadInstructions,
} from 'react-native/Libraries/NewAppScreen';
import { initYaMap } from './src/yaMap/helpers/helpers';
import { getMockClinics } from './src/yaMap/mocks';
import YMap from './src/yaMap/YaMap';

const App = () => {

  initYaMap()

  const clinics = getMockClinics()

  const handleMapPress = () => {
    console.log('pointPress')
  }

  const handlePointPress = () => {
    console.log('mapPress');
  }


  return (
    <SafeAreaView>
      <View style={{ height: Dimensions.get('window').height, width: '100%' }}>
        <Text>YaMap</Text>
        <YMap
          onPointPress={handlePointPress}
          onMapPress={handleMapPress}
          points={JSON.stringify(
            clinics.map((c) => ({
              checkupId: c.checkUpId,
              clinicId: c.clinicId,
              lat: c.lat,
              lon: c.lon,
              price: c.price
            })),
          )}
          style={{
            flex: 1,
          }}
        />
      </View>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  sectionContainer: {
    marginTop: 32,
    paddingHorizontal: 24,
  },
  sectionTitle: {
    fontSize: 24,
    fontWeight: '600',
  },
  sectionDescription: {
    marginTop: 8,
    fontSize: 18,
    fontWeight: '400',
  },
  highlight: {
    fontWeight: '700',
  },
});

export default App;

// const clinics = [
//   { checkUpId: 'Clinic 1', clinicId: 'Clinic 1', lat: 55.754242, lon: 37.618489, price: '10000' },
//   { checkUpId: 'Clinic 2', clinicId: 'Clinic 2', lat: 55.753246, lon: 37.6486, price: '12000' },
//   { checkUpId: 'Clinic 3', clinicId: 'Clinic 3', lat: 55.752290, lon: 37.6204235, price: '15000' },
//   { checkUpId: 'Clinic 4', clinicId: 'Clinic 4', lat: 55.7545, lon: 37.619428, price: '12500' },
//   { checkUpId: 'Clinic 5', clinicId: 'Clinic 5', lat: 55.75108, lon: 37.616423122, price: '10200' },
//   { checkUpId: 'Clinic 6', clinicId: 'Clinic 6', lat: 55.755467, lon: 37.615423179, price: '1555' },
//   { checkUpId: 'Clinic 6', clinicId: 'Clinic 6', lat: 56.755467, lon: 37.615423179, price: '1555' },
//   { checkUpId: 'Clinic 6', clinicId: 'Clinic 6', lat: 55.467, lon: 37.615423179, price: '1555' },
//   { checkUpId: 'Clinic 6', clinicId: 'Clinic 6', lat: 57.0467, lon: 37.615423179, price: '1555' },
//   { checkUpId: 'Clinic 6', clinicId: 'Clinic 6', lat: 58.755467, lon: 38.615423179, price: '1555' },
//   { checkUpId: 'Clinic 6', clinicId: 'Clinic 6', lat: 59.755467, lon: 38.615423179, price: '1555' },
// ]