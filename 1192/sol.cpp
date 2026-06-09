#include <bits/stdc++.h>

using namespace std;

class Solution {
    public:
    int ROWS{}, COLS{};
    vector<string> grid{};
    vector<pair<int,int>> dirs{{1,0}, {-1,0}, {0,1}, {0,-1}};
    void dfs(int i, int j) {
        if (i<0 or j<0 or i>=ROWS or j>=COLS or grid[i][j]=='#') return;
        grid[i][j]='#';
        for (auto& dir : dirs) {
            dfs(i+dir.first, j+dir.second);
        }
        return;
    }

    void solve() {
        cin >> ROWS >> COLS;
        string row;
        while (cin>>row) grid.push_back(row);
        int res{};
        for (int i{}; i<ROWS; i++) {
            for (int j{}; j<COLS; j++) {
                if (grid[i][j]=='.') {
                    res++;
                    dfs(i,j);
                }
            }
        }
        cout << res << endl;
    }
};



int main() {
    ios::sync_with_stdio(false);
    cin.tie(0);
    Solution s{};
    s.solve();
    return 0;
}
