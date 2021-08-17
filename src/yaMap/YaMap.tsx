import { requireNativeComponent, ViewPropTypes } from 'react-native';
import PropTypes from 'prop-types';

const YMap = requireNativeComponent('RNTMap');

YMap.propTypes = {
    onPointPress:  PropTypes.func.isRequired,
    onMapPress: PropTypes.func.isRequired,
    points: PropTypes.string.isRequired,
};

export default YMap;