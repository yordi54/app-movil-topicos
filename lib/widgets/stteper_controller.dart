class StepperController {
  int _currentStep = 0;
  int get currentStep => _currentStep;

  void next() {
    _currentStep++;
  }

  void previous() {
    _currentStep--;
  }

  void dispose(){
    _currentStep = 0;
    
  }
}