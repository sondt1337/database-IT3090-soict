-- Bảng đội bóng
CREATE TABLE DOIBONG (
    MaDoi VARCHAR(2) PRIMARY KEY,
    TenDoi VARCHAR(100),
    NamTL INT
);

-- Bảng cầu thủ
CREATE TABLE CAUTHU (
    MaCauThu VARCHAR(2) PRIMARY KEY,
    TenCauThu VARCHAR(50),
    Phai BIT,
    NgaySinh DATETIME,
    NoiSinh VARCHAR(50),
    MaDoi VARCHAR(2),
    FOREIGN KEY (MaDoi) REFERENCES DOIBONG(MaDoi)
);

-- Bảng thi đấu
CREATE TABLE THIDAU (
    MaDoi VARCHAR(2) PRIMARY KEY,
    NgayThiDau DATETIME,
    HieuSo VARCHAR(8),
    KetQua BIT,
    FOREIGN KEY (MaDoi) REFERENCES DOIBONG(MaDoi)
);

-- Bảng phạt
CREATE TABLE PENELTY (
    MaPhat VARCHAR(2) PRIMARY KEY,
    MaCT VARCHAR(2),
    TienPhat NUMERIC,
    LoaiThe VARCHAR(1),
    NgayPhat DATETIME,
    FOREIGN KEY (MaCT) REFERENCES CAUTHU(MaCauThu)
);



-- Nhập liệu vào các bảng
-- Nhập liệu cho bảng đội bóng (DOIBONG)
INSERT INTO DOIBONG (MaDoi, TenDoi, NamTL) VALUES
    ('D2', 'Barcelona', 1899),
    ('D3', 'Chelsea', 1905),
    ('D4', 'Real Madrid', 1902),
    ('D5', 'Bayern Munich', 1900),
    ('D6', 'Manchester United', 1878);

-- Nhập liệu cho bảng cầu thủ (CAUTHU)
INSERT INTO CAUTHU (MaCauThu, TenCauThu, Phai, NgaySinh, NoiSinh, MaDoi) VALUES
    ('T2', 'Lionel Messi', 1, '1987-06-24', 'Rosario', 'D2'),
    ('T3', 'Cristiano Ronaldo', 1, '1985-02-05', 'Funchal', 'D4'),
    ('T4', 'Golo Kante', 1, '1991-03-29', 'Paris', 'D3'),
    ('T5', 'Robert Lewandowski', 1, '1988-08-21', 'Warsaw', 'D5'),
    ('T6', 'Bruno Fernandes', 1, '1994-09-08', 'Maia', 'D6');

-- Nhập liệu cho bảng thi đấu (THIDAU)
INSERT INTO THIDAU (MaDoi, NgayThiDau, HieuSo, KetQua) VALUES
    ('D2', '2020-01-01', '3-0', 1),
    ('D3', '2020-01-02', '1-1', 0),
    ('D4', '2020-01-02', '0-2', 0),
    ('D5', '2020-01-03', '4-2', 1),
    ('D6', '2020-01-03', '1-1', 0);

-- Nhập liệu cho bảng phạt (PENELTY)
INSERT INTO PENELTY (MaPhat, MaCT, TienPhat, LoaiThe, NgayPhat) VALUES
    ('P2', 'T2', 150, 'V', '2019-01-03'),
    ('P3', 'T3', 200, 'D', '2019-01-04'),
    ('P4', 'T4', 50, 'V', '2019-01-05'),
    ('P5', 'T5', 120, 'V', '2019-01-06'),
    ('P6', 'T6', 180, 'D', '2019-01-07');


-- a. Đưa ra thông tin các cầu thủ từ 35 tuổi trở lên. 
SELECT TenCauThu, NgaySinh, NoiSinh, CASE WHEN Phai = 1 THEN 'Nam' ELSE 'Nữ' END AS Phai
FROM CAUTHU
WHERE DATEDIFF(YEAR, NgaySinh, GETDATE()) >= 35;

-- b. Thống kê số cầu thủ theo loại thẻ phạt:
SELECT LoaiThe, COUNT(*) AS SoLuongCauThu, SUM(TienPhat) AS TongTienPhat
FROM PENELTY
GROUP BY LoaiThe;

-- c. Danh sách cầu thủ có số lần phạt thẻ đỏ nhiều nhất năm 2019:
WITH RedCardCount AS (
    SELECT MaCT, COUNT(*) AS SoLanTheDo
    FROM PENELTY
    WHERE LoaiThe = 'D' AND YEAR(NgayPhat) = 2019
    GROUP BY MaCT
)
SELECT CAUTHU.TenCauThu, CAUTHU.Phai, CAUTHU.NgaySinh, CAUTHU.NoiSinh, RedCardCount.SoLanTheDo
FROM RedCardCount
JOIN CAUTHU ON CAUTHU.MaCauThu = RedCardCount.MaCT
WHERE RedCardCount.SoLanTheDo = (SELECT MAX(SoLanTheDo) FROM RedCardCount);


-- d. Danh sách đội bóng với Hiệu Số bé nhất vào năm 2020:
WITH GoalDifference AS (
    SELECT MaDoi, SUM(CAST(LEFT(HieuSo, CHARINDEX('-', HieuSo) - 1) AS INT)) AS TotalGoals
    FROM THIDAU
    WHERE YEAR(NgayThiDau) = 2020
    GROUP BY MaDoi
)
SELECT DOIBONG.MaDoi, DOIBONG.TenDoi, GoalDifference.TotalGoals
FROM DOIBONG
JOIN GoalDifference ON DOIBONG.MaDoi = GoalDifference.MaDoi
ORDER BY TotalGoals;


-- e. Đội bóng trẻ có năm thành lập sau 1990, có số lần thắng ít nhất.
WITH WinningCount AS (
    SELECT MaDoi, COUNT(*) AS SoLanThang
    FROM THIDAU
    WHERE KetQua = 1
    GROUP BY MaDoi
)
SELECT TOP 1 DOIBONG.MaDoi, DOIBONG.TenDoi, DOIBONG.NamTL, WinningCount.SoLanThang
FROM DOIBONG
JOIN WinningCount ON DOIBONG.MaDoi = WinningCount.MaDoi
WHERE DOIBONG.NamTL > 1990
ORDER BY SoLanThang;


-- f.  Tạo các Rule
-- Kiểm tra loại thẻ phạt chỉ có thể là "D" hoặc "V"
CREATE RULE CheckLoaiTheRule AS
    @LoaiThe IN ('D', 'V');

-- Kiểm tra ngày thi đấu không quá ngày hiện tại
CREATE RULE CheckNgayThiDauRule AS
    @NgayThiDau <= GETDATE();


