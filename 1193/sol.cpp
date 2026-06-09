#include <bits/stdc++.h>

using namespace std;

struct PairHash {
    template <typename t1, typename t2>
    size_t operator()(const pair<t1,t2> &p) const {
        return hash<t1>{}(p.first) ^ hash<t2>{}(p.second);
    }
};

class Solution {
    public:
    int ROWS{}, COLS{};
    vector<string> grid{};
    vector<tuple<int,int,char>> dirs{{1,0,'D'}, {-1,0,'U'}, {0,1,'R'}, {0,-1,'L'}};
    string bfs(int start_i, int start_j) {
        deque<pair<pair<int,int>,string>> q{{{start_i,start_j},""}};
        unordered_set<pair<int,int>, PairHash> visit{};
        while (not q.empty()) {
            for (int _{}; _<q.size(); _++) {
                auto node = q.front();
                q.pop_front();
                auto i = node.first.first;
                auto j = node.first.second;
                auto p = node.second;
                if (i<0 or j<0 or i>=ROWS or j>=COLS or visit.contains({i,j})) continue;
                visit.insert({i,j});
                if (grid[i][j]=='.' or grid[i][j]=='A') {
                    for (auto dir : dirs) {
                        q.push_back({{i+get<0>(dir), j+get<1>(dir)}, p+get<2>(dir)});
                    }
                }
                else if (grid[i][j]=='B') return p;
            }
        }
        return "";
    }

    void solve() {
        cin >> ROWS >> COLS;
        string row;
        while (cin>>row) grid.push_back(row);
        for (int i{}; i<ROWS; i++) {
            for (int j{}; j<COLS; j++) {
                if (grid[i][j]=='A') {
                    auto p = bfs(i,j);
                    if (p.empty()) {cout<<"NO"<<endl; return;}
                    else {
                        cout<<"YES"<<endl<<p.size()<<endl<<p<<endl;
                        return;
                    }
                }
            }
        }
    }
};



int main() {
    ios::sync_with_stdio(false);
    cin.tie(0);
    Solution s{};
    s.solve();
    return 0;
}
