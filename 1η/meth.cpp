#include <iostream>
#include <fstream>
using namespace std;

// https://cs.stackexchange.com/questions/129353/find-the-length-of-the-longest-subarray-having-sum-greater-than-k
// https://www.geeksforgeeks.org/longest-subarray-having-average-greater-than-or-equal-to-x-set-2/

int maxIndexDiff(int arr[], int n)
{
    int maxDiff;
    int i, j;

    int LMin[n], RMax[n];


    LMin[0] = arr[0];
    for (i = 1; i < n; ++i)
        LMin[i] = min(arr[i], LMin[i - 1]);



    RMax[n - 1] = arr[n - 1];
    for (j = n - 2; j >= 0; --j)
            RMax[j] = max(arr[j], RMax[j + 1]);



    i = 0, j = 0, maxDiff = -1;
    while (j < n && i < n) {
        if (LMin[i] <= RMax[j]) {
            maxDiff = max(maxDiff, j - i);
            j = j + 1;
        }
        else
            i = i + 1;
    }

    return maxDiff;
}

void calcprefix(int arr[], int n)
{
    int s = 0;
    for (int i = 1; i < n; i++) {
        s += arr[i];
        arr[i] = s;

    }
}

int longestsubarray(int arr[], int n, int x)
{

    calcprefix(arr, n);

    return maxIndexDiff(arr, n);
}

int main(int argc, char **argv)
{
    int N, M;
    ifstream myfile;

    myfile.open(argv[1]);

    myfile >> M;
    myfile >> N;

    int * arr = new int[M+1];
    for(int i = 1; i < M+1; ++i)
    {
      int h;
      myfile >> h;
      arr[i] = -h-N;
    }
    arr[0] = 0;

    cout << longestsubarray(arr, M+1, 0) << endl;

    delete[] arr;
    return 0;
}
