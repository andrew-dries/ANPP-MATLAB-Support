"""
This module provides functionality to load all data from processed log files.
"""

import os
import scipy.io as sio
from typing import Dict, Any, Optional, Union, List

# TODO: These functions need to be converted from MATLAB to Python
# For now they are placeholders that return empty dictionaries
def load_device_information(filepath: str) -> Dict[str, Any]:
    return {'device_id': 0}

def load_configuration(filepath: str, device_id: int) -> Dict[str, Any]:
    return {}

def load_log_converter(filepath: str) -> Dict[str, Any]:
    return {}

def load_state_log(filepath: str, time_filter: Optional[Dict[str, List[float]]]) -> Dict[str, Any]:
    return {}

def load_status_log(filepath: str, time_filter: Optional[Dict[str, List[float]]]) -> Dict[str, Any]:
    return {}

def load_sensor_log(filepath: str, time_filter: Optional[Dict[str, List[float]]]) -> Dict[str, Any]:
    return {}

def load_satellites_log(filepath: str, time_filter: Optional[Dict[str, List[float]]]) -> Dict[str, Any]:
    return {}

def load_rawGNSS_log(filepath: str, time_filter: Optional[Dict[str, List[float]]]) -> Dict[str, Any]:
    return {}

def load_euler_sd_log(filepath: str, time_filter: Optional[Dict[str, List[float]]]) -> Dict[str, Any]:
    return {}

def load_north_seeking_status(filepath: str, time_filter: Optional[Dict[str, List[float]]]) -> Dict[str, Any]:
    return {}

def load_pedestrian_dead_reckoning_log(filepath: str, time_filter: Optional[Dict[str, List[float]]]) -> Dict[str, Any]:
    return {}

def load_body_velocity_log(filepath: str, time_filter: Optional[Dict[str, List[float]]]) -> Dict[str, Any]:
    return {}

def load_body_acceleration_log(filepath: str, time_filter: Optional[Dict[str, List[float]]]) -> Dict[str, Any]:
    return {}

def load_velocity_sd_log(filepath: str, time_filter: Optional[Dict[str, List[float]]]) -> Dict[str, Any]:
    return {}

def load_external_velocity_log(filepath: str, time_filter: Optional[Dict[str, List[float]]]) -> Dict[str, Any]:
    return {}

def load_external_body_velocity_log(filepath: str, time_filter: Optional[Dict[str, List[float]]]) -> Dict[str, Any]:
    return {}

def load_extended_satellites_log(filepath: str, time_filter: Optional[Dict[str, List[float]]]) -> Dict[str, Any]:
    return {}

def load_odometer_state_log(filepath: str, time_filter: Optional[Dict[str, List[float]]]) -> Dict[str, Any]:
    return {}

def load_bias_state_log(filepath: str, time_filter: Optional[Dict[str, List[float]]]) -> Dict[str, Any]:
    return {}

def load_wind_log(filepath: str, time_filter: Optional[Dict[str, List[float]]]) -> Dict[str, Any]:
    return {}

def load_adu_log(filepath: str, time_filter: Optional[Dict[str, List[float]]]) -> Dict[str, Any]:
    return {}

def load_detailed_satellites_log(filepath: str, time_filter: Optional[Dict[str, List[float]]]) -> Dict[str, Any]:
    return {}

def load_geoid_height_log(filepath: str, time_filter: Optional[Dict[str, List[float]]]) -> Dict[str, Any]:
    return {}

def load_uptime_log(filepath: str, time_filter: Optional[Dict[str, List[float]]]) -> Dict[str, Any]:
    return {}

def load_post_processed_kinematica_log(filepath: str, time_filter: Optional[Dict[str, List[float]]]) -> Dict[str, Any]:
    return {}

def load_processed_log_files(folderpath: str, time_filter: Optional[Dict[str, List[float]]] = None) -> Dict[str, Any]:
    """
    Load all data from files that exist in the specified folder.
    
    Args:
        folderpath (str): Path to the folder containing the log files
        time_filter (Dict[str, List[float]], optional): Dictionary containing time_interval key with 
            a list of two floats [start_time, end_time]. Defaults to None.
        
    Returns:
        Dict[str, Any]: Dictionary containing all loaded data
        
    Raises:
        ValueError: If time interval is invalid or if data to be saved is empty
    """
    data = {}

    # Validate time filter
    if time_filter is not None:
        if time_filter.get('time_interval'):
            time_interval = time_filter['time_interval']
            if len(time_interval) != 2:
                raise ValueError("Time interval size incorrect!")
            if time_interval[0] >= time_interval[1]:
                raise ValueError("Time interval first element is larger than or equal to second element! "
                              "Time interval should consist of [min time, max time].")

    # Check for existing .mat file
    mat_file_path = os.path.join(folderpath, 'log.mat')
    if os.path.isfile(mat_file_path):
        try:
            mat_data = sio.loadmat(mat_file_path)
            if 'data' in mat_data and 'time_interval_save' in mat_data:
                # Check time intervals match
                if (time_filter is None and 
                    (mat_data['time_interval_save'].size == 0 or 
                     mat_data['time_interval_save'] is None)):
                    return mat_data['data']
                elif (time_filter and mat_data['time_interval_save'].size > 0 and 
                      time_filter['time_interval'][0] == mat_data['time_interval_save'][0] and 
                      time_filter['time_interval'][1] == mat_data['time_interval_save'][1]):
                    return mat_data['data']
                
            print("Reloading log data! Time intervals did not match.")
        except Exception as e:
            print(f"Error loading .mat file: {e}. Proceeding with reload.")

    # Load device information
    device_info_path = os.path.join(folderpath, 'DeviceInformation.txt')
    if os.path.isfile(device_info_path):
        data['device_information'] = load_device_information(device_info_path)
        device_id = data['device_information'].get('device_id', 0)
    else:
        device_id = 0

    # Dictionary mapping file names to their respective loading functions
    file_loaders = {
        'Configuration.txt': ('configuration', lambda p: load_configuration(p, device_id)),
        'LogConverter.txt': ('log_converter', load_log_converter),
        'State.csv': ('state', lambda p: load_state_log(p, time_filter)),
        'Status.csv': ('status', lambda p: load_status_log(p, time_filter)),
        'RawSensors.csv': ('raw_sensors', lambda p: load_sensor_log(p, time_filter)),
        'Satellites.csv': ('satellites', lambda p: load_satellites_log(p, time_filter)),
        'RawGNSS.csv': ('raw_gnss', lambda p: load_rawGNSS_log(p, time_filter)),
        'EulerStandardDeviation.csv': ('euler_sd', lambda p: load_euler_sd_log(p, time_filter)),
        'NorthSeekingStatus.csv': ('north_seeking_status', lambda p: load_north_seeking_status(p, time_filter)),
        'PedestrianDeadReckoning.csv': ('pdr', lambda p: load_pedestrian_dead_reckoning_log(p, time_filter)),
        'BodyVelocity.csv': ('body_velocity', lambda p: load_body_velocity_log(p, time_filter)),
        'BodyAcceleration.csv': ('body_acceleration', lambda p: load_body_acceleration_log(p, time_filter)),
        'VelocityStandardDeviation.csv': ('velocity_sd', lambda p: load_velocity_sd_log(p, time_filter)),
        'ExternalVelocity.csv': ('external_velocity', lambda p: load_external_velocity_log(p, time_filter)),
        'ExternalBodyVelocity.csv': ('external_body_velocity', lambda p: load_external_body_velocity_log(p, time_filter)),
        'ExtendedSatellites.csv': ('extended_satellites', lambda p: load_extended_satellites_log(p, time_filter)),
        'OdometerState.csv': ('odometer_state', lambda p: load_odometer_state_log(p, time_filter)),
        'Biases.csv': ('bias', lambda p: load_bias_state_log(p, time_filter)),
        'Wind.csv': ('wind_data', lambda p: load_wind_log(p, time_filter)),
        'ExternalAirData.csv': ('adu_data', lambda p: load_adu_log(p, time_filter)),
        'DetailedSatellites.csv': ('detailed_satellites_data', lambda p: load_detailed_satellites_log(p, time_filter)),
        'GeoidHeight.csv': ('geoid_height_data', lambda p: load_geoid_height_log(p, time_filter)),
        'UpTime.csv': ('uptime_data', lambda p: load_uptime_log(p, time_filter)),
        'PostProcessed.csv': ('kinematica_data', lambda p: load_post_processed_kinematica_log(p, time_filter))
    }

    # Load all available files
    for filename, (key, loader_func) in file_loaders.items():
        file_path = os.path.join(folderpath, filename)
        if os.path.isfile(file_path):
            data[key] = loader_func(file_path)

    # Save data to .mat file if not empty
    if data:
        time_interval_save = time_filter['time_interval'] if time_filter else None
        save_dict = {
            'data': data,
            'time_interval_save': time_interval_save if time_interval_save else []
        }
        sio.savemat(mat_file_path, save_dict)
    else:
        raise ValueError("Check your directory, data to be saved is empty!")

    return data