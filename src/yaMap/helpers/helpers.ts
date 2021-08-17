import { NativeModules } from "react-native";

export const initYaMap = () => {
    try {
        NativeModules.YMap.initWithKey('e66f08c2-73e1-4788-a554-129052ac27f4');
    } catch (e) {
        console.error(e);
    }

}