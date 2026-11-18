 Multi-Crop Plant Disease Detection and Mobile-Based Monitoring System

Installation and Usage

Model Training

1. Clone or download this repository.
2. Install the required Python packages.
3. Open the relevant crop-specific Jupyter Notebook.
4. Configure the dataset directory paths.
5. Execute the notebook cells to reproduce the training workflow.

Install the Python dependencies using:

pip install -r requirements.txt


The required package versions and dependencies should be checked against the individual training notebooks.

Mobile Application

1. Install Flutter and the required Android development tools.
2. Open the Mobile Application directory.
3. Install the Flutter dependencies:
flutter pub get
4. Configure the required Firebase project settings.
5. Ensure the required TensorFlow Lite model files are available in the application assets.
6. Run the application:
flutter run
Additional configuration may be required depending on the Firebase project and Android development environment.

The repository is intended to support transparency and reproducibility of the model development and mobile application implementation.

Users should configure their own dataset paths and Firebase credentials before executing the code. Training results may vary depending on the hardware, software environment, dataset version, and training configuration.

Acknowledgements

The authors acknowledge the original providers of the publicly available plant disease datasets and the developers of the open-source frameworks and libraries used in this research.
For questions about the implementation or research collaboration, please contact the repository maintainer through GitHub.