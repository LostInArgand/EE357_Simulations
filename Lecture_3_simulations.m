% Message Signal
[y,Fs] = audioread('test1.ogg');

%plot frequency spectrum
figure(1);
freqaxis = linspace(-Fs/2, Fs/2, length(y))';
Y = fftshift(fft(y)) / length(y);
subplot(3, 1, 1);
plot(freqaxis, abs(Y));
title('Magnitude Spectrum of the message signal');
xlabel('Frequency (/Hz)');
ylabel('Amplitude');

% Carrier Signal
fc = 10000;
t_c = [0:1/Fs:(length(y)/Fs) - (1/Fs)]';
Ac = 3;
y_c = Ac*cos(2*pi*fc*t_c);
Y_c = fftshift(fft(y_c)) / length(y_c);
subplot(3, 1, 2);
plot(freqaxis, abs(Y_c));
title('Magnitude Spectrum of the carrier signal');
xlabel('Frequency (/Hz)');
ylabel('Amplitude');

% DSB-SC Signal
y_t = y_c.*y;
Y_t = fftshift(fft(y_t)) / length(y_t);
subplot(3, 1, 3);
plot(freqaxis, abs(Y_t));
title('Magnitude Spectrum of the DSB-SC signal');
xlabel('Frequency (/Hz)');
ylabel('Amplitude');


% Coherent Detector

% Local Signal
Ac_local = 2;
phi = pi/10;
delta_f = 0;
y_local = Ac_local*cos((2*pi*(fc + delta_f)*t_c) + phi);
Y_local = fftshift(fft(y_local)) / length(y_local);
figure(2);
subplot(3, 1, 1);
plot(freqaxis, abs(Y_local));
title('Magnitude Spectrum of locally generated signal');
xlabel('Frequency (/Hz)');
ylabel('Amplitude');

% Product Modulator
v = y_t .* y_local;
V = fftshift(fft(v)) / length(v);
subplot(3, 1, 2);
plot(freqaxis, abs(V));
title('Magnitude Spectrum of the demodulated signal before filtering');
xlabel('Frequency (/Hz)');
ylabel('Amplitude');

% Low pass filter
N = 10;
LP_IIR = dsp.LowpassFilter('SampleRate',Fs,'FilterType','IIR', 'DesignForMinimumOrder',false,'FilterOrder',N, 'PassbandFrequency',5000,'PassbandRipple',0.01,'StopbandAttenuation',80);
k = 0.5*Ac*Ac_local*cos(phi);
out = LP_IIR(v) / k;
OUT = fftshift(fft(out)) / length(out);
subplot(3, 1, 3);
plot(freqaxis, abs(OUT));
title('Magnitude Spectrum of the demodulated signal after filtering');
xlabel('Frequency (/Hz)');
ylabel('Amplitude');

% Play demodulated and filtered signal
sound(out, Fs);

% Time domain plots
figure(3);
subplot(3, 2, 1);
plot(t_c, y);
title('Message Signal');
xlabel('Time (/s)');
ylabel('Amplitude');

subplot(3, 2, 2);
plot(t_c, y_c);
title('Carrier Signal');
xlabel('Time (/s)');
ylabel('Amplitude');

subplot(3, 2, 3);
plot(t_c, y_t);
title('DSB-SC Signal');
xlabel('Time (/s)');
ylabel('Amplitude');

subplot(3, 2, 4);
plot(t_c, y_local);
title('Locally Generated Signal');
xlabel('Time (/s)');
ylabel('Amplitude');

subplot(3, 2, 5);
plot(t_c, v);
title('Demodulated signal before filtering');
xlabel('Time (/s)');
ylabel('Amplitude');

subplot(3, 2, 6);
plot(t_c, out);
title('Demodulated and filtered signal');
xlabel('Time (/s)');
ylabel('Amplitude');

