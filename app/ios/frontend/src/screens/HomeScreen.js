import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  SafeAreaView,
  Image,
  ActivityIndicator,
  ScrollView,
  Platform,
  Alert
} from 'react-native';
import CameraButton from '../components/CameraButton';
import DescriptionBox from '../components/DescriptionBox';
import * as ImagePicker from 'expo-image-picker';
import { Audio } from 'expo-av';
import { processImage } from '../utils/api';

export default function HomeScreen() {
  const [image, setImage] = useState(null);
  const [description, setDescription] = useState('');
  const [loading, setLoading] = useState(false);
  const [sound, setSound] = useState();

  useEffect(() => {
    requestPermissions();
    return sound ? () => sound.unloadAsync() : undefined;
  }, [sound]);

  const requestPermissions = async () => {
    if (Platform.OS !== 'web') {
      const { status } = await ImagePicker.requestCameraPermissionsAsync();
      if (status !== 'granted') {
        Alert.alert(
          '需要權限',
          '需要相機權限才能使用此功能。',
          [{ text: '明白' }]
        );
      }
    }
  };

  const handleImage = async () => {
    try {
      const result = await ImagePicker.launchCameraAsync({
        mediaTypes: ImagePicker.MediaTypeOptions.Images,
        quality: 1,
        allowsEditing: true,
        aspect: [4, 3],
      });

      if (!result.canceled && result.assets[0]) {
        setImage(result.assets[0].uri);
        setLoading(true);
        const response = await processImage(result.assets[0].uri);
        setDescription(response.description);
        
        if (response.audioUrl) {
          const { sound: audioSound } = await Audio.Sound.createAsync(
            { uri: response.audioUrl },
            { shouldPlay: true }
          );
          setSound(audioSound);
        }
      }
    } catch (error) {
      console.error('Error:', error);
      Alert.alert('錯誤', '處理圖片時出現問題');
    } finally {
      setLoading(false);
    }
  };

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView contentContainerStyle={styles.scrollContent}>
        <Text style={styles.title}>AEyes-HK</Text>
        <Text style={styles.subtitle}>視障人士的眼睛</Text>

        <CameraButton 
          onPress={handleImage} 
          loading={loading} 
        />

        {loading && (
          <ActivityIndicator 
            size="large" 
            color="#007AFF" 
            style={styles.loader} 
          />
        )}

        {image && (
          <View style={styles.imageContainer}>
            <Image 
              source={{ uri: image }} 
              style={styles.image}
              resizeMode="cover"
            />
          </View>
        )}

        {description && (
          <DescriptionBox description={description} />
        )}
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#F5F5F5',
  },
  scrollContent: {
    padding: 20,
  },
  title: {
    fontSize: 36,
    fontWeight: 'bold',
    textAlign: 'center',
    color: '#000',
    marginTop: Platform.OS === 'ios' ? 40 : 20,
  },
  subtitle: {
    fontSize: 16,
    color: '#666',
    textAlign: 'center',
    marginBottom: 30,
  },
  imageContainer: {
    width: '100%',
    height: 300,
    borderRadius: 10,
    overflow: 'hidden',
    marginVertical: 20,
    backgroundColor: '#FFF',
    elevation: 3,
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowOpacity: 0.25,
    shadowRadius: 3.84,
  },
  image: {
    width: '100%',
    height: '100%',
  },
  loader: {
    marginVertical: 20,
  }
});
