%% EMG - Myo Test file
%  Author: Stefan Kastner
%  29.04.2022
%  Used SOUP MyoMex

%% Installation of the MyoMex

install_myo_mex;                        % adds directory to the matlab path  


sdk_path='C:\Users\kaste\OneDrive\Dokumente\Hochschule\Master\Masterthesis\Software\Matlab\myo-sdk-win-0.9.0';    % hardcoded sdk path (has to change when using on another PC)
build_myo_mex(sdk_path);
countMyos = 1;                          % determines the amount of Myos used
timeduration=10;
mm = MyoMex(countMyos);
m1 = mm.myoData(1);
directory = 'C:\Users\kaste\OneDrive\Dokumente\Hochschule\Master\Masterthesis\Software\Matlab\Raw_Data';




pause(0.1);
m1.emg

m1.isStreaming;
timerVal=tic;
h=animatedline('Color','r');
z=animatedline('Color','b');

while(m1.isStreaming)
    timeEMG = m1.timeEMG_log;
    if ~isempty(timeEMG)
        indexEMG = find(timeEMG>=(timeEMG(end)));       % gets the Index by finding the positon of timeEMG changes
        tEMG = timeEMG(indexEMG);                       % gets the time when there is a change
        data_emg = m1.emg_log(indexEMG,:);              % determines the data

       
        addpoints(h,tEMG,data_emg(:,1));
        addpoints(z,tEMG,data_emg(:,2));
        drawnow

        


        if (toc(timerVal)>timeduration)

            all_data=m1.emg_log;
            T = array2table(all_data);
            T.Properties.VariableNames(1:8)={'Sensor1','Sensor 2','Sensor 3','Sensor 4','Sensor 5','Sensor 6','Sensor 7','Sensor 8'};
            if ~exist(directory,'dir')
                directory=pwd;
            end
            
            fileName='EMG_raw_data.xlsx';
            [file,path]=uiputfile(fileName,'Save file name');

            if file == 0
               
                return;
            end

            writetable(T,fullfile(path,file));
            m1.stopStreaming();
            
        end
    
    end
end

    



