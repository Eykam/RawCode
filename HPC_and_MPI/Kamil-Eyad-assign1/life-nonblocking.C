#include <mpi.h>
#include <ctime>
#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
using namespace std;

/*
 * Reads the input file line by line and stores it in a 2D matrix.
 */
void read_input_file(int **life, string const &input_file_name) {
    
    // Open the input file for reading.
    ifstream input_file;
    input_file.open(input_file_name);
    if (!input_file.is_open())
        perror("Input file cannot be opened");

    string line, val;
    int x, y;
    while (getline(input_file, line)) {
        stringstream ss(line);
        
        // Read x coordinate.
        getline(ss, val, ',');
        x = stoi(val);
        
        // Read y coordinate.
        getline(ss, val);
        y = stoi(val);

        // Populate the life matrix.
        life[x][y] = 1;
    }
    input_file.close();
}

/* 
 * Writes out the final state of the 2D matrix to a csv file. 
 */
void write_output(int **result_matrix, int X_limit, int Y_limit,
                  string const &input_name, int num_of_generations) {
    
    // Open the output file for writing.
    ofstream output_file;
    string input_file_name = input_name.substr(0, input_name.length() - 5);
    output_file.open(input_file_name + "." + to_string(num_of_generations) +
                    ".csv");
    if (!output_file.is_open())
        perror("Output file cannot be opened");
    
    // Output each live cell on a new line. 
    for (int i = 0; i < X_limit; i++) {
        for (int j = 0; j < Y_limit; j++) {
            if (result_matrix[i][j] == 1) {
                output_file << i << "," << j << "\n";
            }
        }
    }

    output_file.close();
}

/*
 * Processes the life array for the specified number of iterations.
 */
void compute(int **life, int **previous_life, int *bottomRecvRow, int *topRecvRow, int X_limit, int Y_limit, int rank
             , MPI_Request requestTopSend, MPI_Request requestBottomSend, MPI_Request requestTopRecv, MPI_Request requestBottomRecv, int size) {
    int neighbors = 0;

    // Update the previous_life matrix with the current life matrix state.
    for (int i = 0; i < X_limit; i++) {
        for (int j = 0; j < Y_limit; j++) {
            previous_life[i + 1][j + 1] = life[i][j];
        }
    }

    // For simulating each generation, calculate the number of live
    // neighbors for each cell and then determine the state of the cell in
    // the next iteration.
    for (int i = 1; i < X_limit + 1; i++) {
        for (int j = 1; j < Y_limit + 1; j++) {

            if(i == 1){
                if(rank != 0){
                    // cout << "\nwaiting for bottomRow.....\n";
                    MPI_Wait(&requestBottomRecv, MPI_STATUS_IGNORE);
                }
                
                if(rank == 0 ){
                    // cout << "Bottom Received Row for 1: \n";
                    // cout << "\nBottom row: [" << i << "," << j << "]\n";
                    // cout << "\n[i-1][j-1]: " << bottomRecvRow[j-2] << " [i-1][j]: "<< bottomRecvRow[j-1] 
                    // << " [i-1][j+1]: " << bottomRecvRow[j] << " [i][j-1]: " << previous_life[i][j - 1] 
                    // << " [i][j+1]: " << previous_life[i][j + 1] << " [i+1][j-1]: " << previous_life[i + 1][j - 1] 
                    // << " [i+1][j]: " << previous_life[i + 1][j]<< " [i+1][j+1]: " << previous_life[i + 1][j + 1];
                    // // for (int z = 0; z < Y_limit; z++){
                    // //     cout << bottomRecvRow[z] << " ";
                    // // }
    
                }

                if(j == 1){
                    neighbors = previous_life[i-1][j-1] + bottomRecvRow[j-1] +
                    bottomRecvRow[j] + previous_life[i][j - 1] +
                    previous_life[i][j + 1] + previous_life[i + 1][j - 1] +
                    previous_life[i + 1][j] + previous_life[i + 1][j + 1];

                }
                else if(j == Y_limit){
                    neighbors = bottomRecvRow[j - 2] + bottomRecvRow[j-1] +
                    previous_life[i - 1][j + 1] + previous_life[i][j - 1] +
                    previous_life[i][j + 1] + previous_life[i + 1][j - 1] +
                    previous_life[i + 1][j] + previous_life[i + 1][j + 1];

                }else{
                    neighbors = bottomRecvRow[j - 2] + bottomRecvRow[j-1] +
                    bottomRecvRow[j] + previous_life[i][j - 1] +
                    previous_life[i][j + 1] + previous_life[i + 1][j - 1] +
                    previous_life[i + 1][j] + previous_life[i + 1][j + 1];

                }
               
            }else if(i == X_limit){

                if (rank != size-1){
                    // cout << "\nwaiting for topRow.....\n";
                    MPI_Wait(&requestTopRecv, MPI_STATUS_IGNORE);
                }


                // if(rank == 0){
                //     // cout << "Top Received Row for 1: \n";
                //     cout << "\nTop row: [" << i << "," << j << "]\n";
                //     cout << "\n[i-1][j-1]: " << previous_life[i - 1][j - 1] << " [i-1][j]: "<< previous_life[i - 1][j] 
                //     << " [i-1][j+1]: " << previous_life[i - 1][j + 1] << " [i][j-1]: " << previous_life[i][j - 1] 
                //     << " [i][j+1]: " << previous_life[i][j + 1] << " [i+1][j-1]: " <<topRecvRow[j - 2] 
                //     << " [i+1][j]: " << topRecvRow[j-1]<< " [i+1][j+1]: " << topRecvRow[j];
                //     // for (int z = 0; z < Y_limit; z++){
                //     //     cout << topRecvRow[z] << " ";
                //     // }
                // }
                if (j == 1){
                    neighbors = previous_life[i - 1][j - 1] + previous_life[i - 1][j] +
                    previous_life[i - 1][j + 1] + previous_life[i][j - 1] +
                    previous_life[i][j + 1] + previous_life[i + 1][j - 1] +
                    topRecvRow[j-1] + topRecvRow[j];
                }
                else if(j == Y_limit){
                    neighbors = previous_life[i - 1][j - 1] + previous_life[i - 1][j] +
                    previous_life[i - 1][j + 1] + previous_life[i][j - 1] +
                    previous_life[i][j + 1] + topRecvRow[j - 2] +
                    topRecvRow[j-1] + previous_life[i + 1][j + 1];
                }else{
                    neighbors = previous_life[i - 1][j - 1] + previous_life[i - 1][j] +
                    previous_life[i - 1][j + 1] + previous_life[i][j - 1] +
                    previous_life[i][j + 1] + topRecvRow[j - 2] +
                    topRecvRow[j-1] + topRecvRow[j];
                }

            }else{
        
                // if (rank == 0){
                //     cout << "Not top or bottom: \n";
                //     cout << "[i-1][j-1]: " << previous_life[i - 1][j - 1] << " [i-1][j]: "<< previous_life[i - 1][j] 
                //     << " [i-1][j+1]: " << previous_life[i - 1][j + 1] << " [i][j-1]: " << previous_life[i][j - 1] 
                //     << " [i][j+1]: " << previous_life[i][j + 1] << " [i+1][j-1]: " << previous_life[i + 1][j - 1] 
                //     << " [i+1][j]: " << previous_life[i + 1][j]<< " [i+1][j+1]: " << previous_life[i + 1][j + 1] << "     \n";
                // }

                neighbors = previous_life[i - 1][j - 1] + previous_life[i - 1][j] +
                previous_life[i - 1][j + 1] + previous_life[i][j - 1] +
                previous_life[i][j + 1] + previous_life[i + 1][j - 1] +
                previous_life[i + 1][j] + previous_life[i + 1][j + 1];
            }
            
            // cout << "PID: " << rank << " [I,J] = [" << i << "," << j << "] Total Neighbors  = " << neighbors << "\n"; 
    
            if (previous_life[i][j] == 0) {
                // A cell is born only when an unoccupied cell has 3 neighbors.
                if(rank != 0 && i == 1){
                    MPI_Wait(&requestBottomSend, MPI_STATUS_IGNORE);
                }

                if(rank != size-1 && i != X_limit){
                    MPI_Wait(&requestTopSend, MPI_STATUS_IGNORE);
                }

                if (neighbors == 3){
                    life[i - 1][j - 1] = 1;
                }

                // cout << "PID: " << rank << " [I,J] = [" << i-1 << "," << j-1 << "] Total Neighbors  = " << neighbors <<" Result:  0 =>" << life[i - 1][j - 1] << "\n"; 

            } else {
                // An occupied cell survives only if it has either 2 or 3 neighbors.
                // The cell dies out of loneliness if its neighbor count is 0 or 1.
                // The cell also dies of overpopulation if its neighbor count is 4-8.
                if(rank != 0 && i == 1){
                    MPI_Wait(&requestBottomSend, MPI_STATUS_IGNORE);
                }

                if(rank != size-1 && i != X_limit){
                    MPI_Wait(&requestTopSend, MPI_STATUS_IGNORE);
                }

                if (neighbors != 2 && neighbors != 3) {

                    life[i - 1][j - 1] = 0;
                }
                // cout << "PID: " << rank << " [I,J] = [" << i-1 << "," << j-1 << "] Total Neighbors  = " << neighbors <<" Result:  1 =>" << life[i - 1][j - 1] << "\n"; 
            }
        }
    }
}


/**
  * The main function to execute "Game of Life" simulations on a 2D board.
  */
int main(int argc, char *argv[]) {
    
    if (argc != 5)
        perror("Expected arguments: ./life <input_file> <num_of_generations> <X_limit> <Y_limit>");

    string input_file_name = argv[1];
    int num_of_generations = stoi(argv[2]);
    int X_limit = stoi(argv[3]);
    int Y_limit = stoi(argv[4]);

    //Initializes board to all 0's based on given x & y limit
    int **life = new int *[X_limit];
    for (int i = 0; i < X_limit; i++) {
        life[i] = new int[Y_limit];
        for (int j = 0; j < Y_limit; j++) {
            life[i][j] = 0;
        }
    }

    // Use previous_life to track the pervious state of the board.
    // Pad the previous_life matrix with 0s on all four sides by setting all
    // cells in the following rows and columns to 0:
    //  1. Row 0
    //  2. Column 0
    //  3. Row X_limit+1
    //  4. Column Y_limit+1
    int **previous_life = new int *[X_limit+2];
    for (int i = 0; i < X_limit+2; i++) {
        previous_life[i] = new int[Y_limit+2];
        for (int j = 0; j < Y_limit+2; j++) {
            previous_life[i][j] = 0;
        }
    }

    read_input_file(life, input_file_name);
    

    int rank, size;
    
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    
    int rowsPerProcess = X_limit/size;
    int rowStart = rowsPerProcess * rank;
    int rowEnd = rowStart + rowsPerProcess;

    int **receivedLife = new int *[rowsPerProcess];
    for (int i = 0; i < rowsPerProcess; i++){
        receivedLife[i] = new int[Y_limit];
        for (int j=0; j < Y_limit; j++){
            receivedLife[i][j] = life[rowStart][j];
        }
        rowStart++;
    }

    rowStart = rowsPerProcess * rank;

    int **receivedPrev = new int *[rowsPerProcess+2];
    for (int i = 0; i < rowsPerProcess + 2; i++){
        receivedPrev[i] = new int[Y_limit];
        for (int j=0; j < Y_limit + 2; j++){
            receivedPrev[i][j] = 0;
        }
        rowStart++;
    }

    int topSendRow [Y_limit];
    int bottomSendRow [Y_limit];
    int topRecvRow [Y_limit];
    int bottomRecvRow [Y_limit];
    MPI_Request requestTopSend;
    MPI_Request requestBottomSend;
    MPI_Request requestTopRecv;
    MPI_Request requestBottomRecv;

    if (rank == size-1){
        memset(topRecvRow, 0, Y_limit*sizeof(int));
    }
    
    if (rank == 0){
        memset(bottomRecvRow, 0, Y_limit*sizeof(int));
    }

    clock_t start = clock();
    for (int numg = 0; numg < num_of_generations; numg++) {
        memcpy(topSendRow, receivedLife[rowsPerProcess-1], Y_limit*sizeof(int));
        memcpy(bottomSendRow, receivedLife[0], Y_limit*sizeof(int));
        
        if(rank != 0){
            MPI_Isend(bottomSendRow, Y_limit, MPI_INT, rank-1, 0, MPI_COMM_WORLD, &requestBottomSend); 
        }
        
        if(rank != size-1){
            MPI_Irecv(topRecvRow, Y_limit, MPI_INT, rank+1, 0, MPI_COMM_WORLD, &requestTopRecv);
        }

        if(rank != size-1){
            MPI_Isend(topSendRow, Y_limit, MPI_INT, rank+1, 1, MPI_COMM_WORLD, &requestTopSend);
        }

        if(rank != 0){
            MPI_Irecv(bottomRecvRow, Y_limit, MPI_INT, rank-1, 1, MPI_COMM_WORLD, &requestBottomRecv);
        }

        compute(receivedLife, receivedPrev, bottomRecvRow, topRecvRow, rowsPerProcess, 
                Y_limit, rank, requestTopSend, requestBottomSend, requestTopRecv, requestBottomRecv, size);
    }
    clock_t end = clock();

    
    int gatheredData[rowsPerProcess * Y_limit * size];
    int buffer [rowsPerProcess*Y_limit];
    
    // if(rank == 0){
    //     cout << "\nBefore aggregated: \n";
    // }

    for (int i = 0; i < rowsPerProcess; i++){
        for (int j = 0; j < Y_limit; j++){
            buffer[i*Y_limit+j] = receivedLife[i][j];
            // if(rank==0){
            //     cout << buffer[i*Y_limit+j] << " ";
            // }
        }
        // if(rank == 0){
        //     cout << "\n";
        // }
    }

    MPI_Gather(buffer, rowsPerProcess*Y_limit, MPI_INT, gatheredData, rowsPerProcess*Y_limit, MPI_INT, 0, MPI_COMM_WORLD);
    
    if(rank == 0){
        for(int i = 0; i < X_limit; i++){
            for(int j = 0; j < Y_limit; j++){
                life[i][j] = gatheredData[i*Y_limit+j];
            }
        }

        write_output(life, X_limit, Y_limit, input_file_name, num_of_generations);
    }

    float times [size];
    float totalTime = float(end - start) / CLOCKS_PER_SEC;

    MPI_Gather(&totalTime, 1, MPI_FLOAT, times, 1, MPI_FLOAT, 0, MPI_COMM_WORLD);
    float sumTimes;
    float currMin;
    float currMax;

    if(rank == 0){
        currMin = times[0];
        currMax = times[0];

        for (int i = 0; i < size; i++){
            sumTimes += times[i];
            if (currMin - times[i] - 1e-9 > 0){
                currMin = times[i];
            }

            if(currMax - times[i] - 1e-9 < 0){
                currMax = times[i];
            }
        }
        
        sumTimes /= size;
        cout << "TIME: Min: " << currMin << " s Avg: " << sumTimes << " s Max: " << currMax << " s\n";
    }
    
    
    MPI_Finalize();

    for (int i = 0; i < X_limit; i++) {
        delete life[i];
    }
    for (int i = 0; i < X_limit+2; i++) {
        delete previous_life[i];
    }
    delete[] life;
    delete[] previous_life;
    
    return 0;
}
