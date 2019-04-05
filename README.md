# Waveform-Generator

This is a simple behavioural implementation of a waveform synthesizer, using wavetables. For more information on implementation, please refer to the Project Paper file which contains an in depth explanation of the overall project, as well as helpful figures and diagrams.

To run a simulation on ModelSim, start a simulation of the top-level file (waveform_top). To view the wave properly, we recommend setting the format of DATA_OUT to analog. TO do this, right click on the output, and from the menu that appears select Format -> Analaog (Custom). The max should be set to 255 and the minimum to 0, and we recommend the pixel size be set to 180, however this is just a preference and this can be sset to whatever produces the desired result. It is also important to force the radix to binary by right clicking and selecting Radix -> Binary. This ensures the simulator interperets the data as binary, and the waveform will appear in the proper shape.

The input WAVE_TYPE refers to the type of wave that you wish to generate, the options being the following:

00 - Sine
01 - Square
10 - Triangle
11 - Sawtooth

The input PERIOD refers to the length of the wave, a longer period will produce a lower frequency wave while a shorter will produce the opposite. For simulation purposes a value of 0000000001 (the minimum) is best. This value produces the highest frequency, and thereofre less simulation time is needed to see the entire wave. However, this value can be played around with to produce longer waves.

The SAMPLE_RATE input refers to how often the datapoints of the wave are sampled while it is being generated. The maximum rate is 11111111 (255), which is what we recommend for initial simulation. As the sample rate gets smaller, the waveform will become less smooth. For more information about minimum sampling rates, we suggest reading into Nyquist Theorem.

We set our CLOCK to the default rate of 100ps, but shorter times of 50ps and below have also worked.

The last two inputs that must be set before simulating are START and RESET. To begin a siulation, set START to 0 and RESET to 1, run the simulation for a clock cycle, and then set START to 1 and RESET to 0. This puts the generator in the default state and ensures it will function properly. Now you may begin generating waveforms. It's easiest to see the waveform by running the program for 100ns and zooming out, which can be done in ModelSim by clicking anywhere along the waveform and then pressing "o" in the keyboard.

Screenshots of our simulations have been provided with this project, feel free to check them out if you are unsure what the result should look like or don't wish to run a simulation yourself.
