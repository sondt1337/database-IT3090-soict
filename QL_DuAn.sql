-- A
-- 1
CREATE TABLE ChucVu
(
    MaChucVu VARCHAR(10) PRIMARY KEY,
    TenChucVu NVARCHAR(30),
    LuongNC INT
)

CREATE TABLE NhanVien
(
    MaNV VARCHAR(10) PRIMARY KEY,
    HoTenNV NVARCHAR(30),
    NgaySinh DATE,
    GioiTinh NVARCHAR(10),
    MaChucVu VARCHAR(10),
    FOREIGN KEY (MaChucVu) REFERENCES ChucVu(MaChucVu)
)

CREATE TABLE DuAn
(
    MaDuAn VARCHAR(10) PRIMARY KEY,
    TenDuAn NVARCHAR(30),
    KinhPhi INT,
    TGBD DATE,
    TGKT DATE
)

CREATE TABLE PhanCong
(
    MaDuAn VARCHAR(10),
    MaNV VARCHAR(10),
    SoNgayCong INT,
    CONSTRAINT KhoaChinh PRIMARY KEY (MaDuAn, MaNV),
    FOREIGN KEY (MaDuAn) REFERENCES DuAn(MaDuAn),
    FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV)
);
-- 2
INSERT INTO ChucVu
VALUES
    ('CN', N'Chủ nhiệm', 750),
    ('TVC', N'Thành viên chính', 550),
    ('TV', N'Thành viên', 450),
    ('KTV', N'Kỹ thuật viên', 300);

INSERT INTO NhanVien
VALUES
    ('GV.0001', N'Lưu Thành Long', '1985-01-10', N'Nam', 'TV'),
    ('GV.0002', N'Lê Thanh Tuấn', '1984-05-15', N'Nam', 'TV'),
    ('GC.0001', N'Nguyễn Văn Nam', '1978-02-15', N'Nam', 'CN'),
    ('GC.0002', N'Nguyễn Lan Hương', '1988-07-18', N'Nữ', 'CN'),
    ('GV.0003', N'Đinh Thu Hằng', '1988-10-19', N'Nữ', 'TV'),
    ('KT.0001', N'Trần Nam Anh', '1979-10-16', N'Nam', 'KTV'),
    ('KT.0002', N'Lê Văn Đồng', '1989-10-20', N'Nam', 'KTV'),
    ('GV.0004', N'Vũ Hồng Hạnh', '1988-10-16', N'Nữ', 'TVC'),
    ('GC.0003', N'Lê Thanh Tùng', '1982-10-23', N'Nam', 'TVC');

INSERT INTO DuAn
VALUES
    ('CB.001', N'Quốc lộ 1A - Ninh Bình', 50000, '2015-01-01', '2018-01-01'),
    ('CB.002', N'Quốc lộ 1A - Nghệ An', 75000, '2015-10-05', '2018-10-05'),
    ('CB.003', N'Quốc lộ 1A - Hà Tĩnh', 56000, '2016-12-12', '2019-12-12'),
    ('CT.001', N'Thông tin CSVC', 2300, '2018-12-12', '2019-12-12'),
    ('CT.002', N'Thông tin phòng TN', 4300, '2017-01-01', '2018-01-01'),
    ('CT.003', N'Thông tin khoa học', 5400, '2018-01-05', '2019-01-05'),
    ('NN.001', N'Cao tốc Hải Phòng', 45000, '2017-05-05', '2019-05-05'),
    ('NN.002', N'Cao tốc Pháp Vân', 55000, '2018-10-09', '2019-10-05'),
    ('DN.001', N'Trạm thu phí Cầu giẽ', 42000, '2017-01-12', '2019-01-12'),
    ('DN.002', N'Đèo Hải Vân', 17000, '2018-01-12', '2020-01-12');

INSERT INTO PhanCong
VALUES
    ('CB.001', 'GC.0001', 120),
    ('CB.001', 'GV.0001', 150),
    ('CB.001', 'GV.0004', 200),
    ('CB.001', 'GV.0002', 200),
    ('CB.001', 'KT.0001', 150),
    ('CT.001', 'GC.0002', 130),
    ('CT.001', 'GV.0004', 130),
    ('CT.001', 'GV.0002', 180),
    ('CT.001', 'GV.0003', 150),
    ('CT.001', 'KT.0001', 200),
    ('CT.001', 'KT.0002', 230),
    ('NN.002', 'GC.0001', 200),
    ('NN.002', 'GC.0003', 250);
-- ('NN.003', 'GC.0002', 150),
-- ('NN.003', 'GV.0004', 200),
-- ('NN.003', 'GC.0003', 300);
-- B
-- 1
SELECT MaDuAn, TenDuAn, TGBD, TGKT
FROM DuAn
WHERE KinhPhi BETWEEN 5000 AND 50000
-- 2
SELECT n.MaNV, n.HoTenNV, COUNT(p.MaDuAn) AS SoDuAnThucHien, SUM(p.SoNgayCong) AS TongSoNgayCong, SUM(p.SoNgayCong * c.LuongNC) AS TongSoTienNhan
FROM NhanVien n, PhanCong p, ChucVu c
WHERE n.MaChucVu = c.MaChucVu
    AND n.MaNV = p.MaNV
GROUP BY n.MaNV, n.HoTenNV;
-- 3
SELECT n.MaNV, n.HoTenNV, c.TenChucVu, SUM(p.SoNgayCong) AS TongSoNgayCong, c.LuongNC, SUM(p.SoNgayCong * c.LuongNC) AS TongLuong
FROM NhanVien n, ChucVu c, PhanCong p, DuAn d
WHERE n.MaNV = p.MaNV
    AND n.MaChucVu = c.MaChucVu
    AND d.MaDuAn = p.MaDuAn
    AND YEAR(d.TGBD) >= 2017
GROUP BY n.MaNV, n.HoTenNV, c.TenChucVu, c.LuongNC
HAVING SUM(p.SoNgayCong * c.LuongNC) >= ALL (
    SELECT SUM(p.SoNgayCong * c.LuongNC)
FROM NhanVien n, ChucVu c, PhanCong p, DuAn d
WHERE n.MaNV = p.MaNV
    AND n.MaChucVu = c.MaChucVu
    AND d.MaDuAn = p.MaDuAn
    AND YEAR(d.TGBD) >= 2017
GROUP BY n.MaNV, n.HoTenNV, c.TenChucVu, c.LuongNC
);
-- 4
SELECT TenDuAn, MaDuAn, KinhPhi, TGBD, TGKT
FROM DuAn
WHERE YEAR(TGBD) <= 2020
    AND YEAR(TGKT) >= 2020
GROUP BY TenDuAn, MaDuAn, KinhPhi, TGBD, TGKT
HAVING DATEDIFF(day, TGBD, TGKT) = MAX(DATEDIFF(day, TGBD, TGKT));
-- 5
SELECT n.MaNV, n.HoTenNV, n.NgaySinh, n.GioiTinh, n.MaChucVu
FROM NhanVien n
WHERE NOT EXISTS 
(
SELECT d.MaDuAn
FROM DuAn d, PhanCong p
WHERE YEAR(d.TGBD) = 2012
    AND n.MaNV = p.MaNV
    AND d.MaDuAn != p.MaDuAn
);
-- 6
SELECT d.*
--, COUNT(n.MaNV) AS SoLuongTV
FROM DuAn d, PhanCong p, NhanVien n
WHERE d.KinhPhi >= 4000
    AND d.MaDuAn = p.MaDuAn
    AND n.MaNV = p.MaNV
    AND n.MaChucVu LIKE 'TV'
GROUP BY d.MaDuAn, d.TenDuAn, d.KinhPhi, d.TGBD, d.TGKT
HAVING COUNT(n.MaNV) >= ALL (
    SELECT COUNT(n.MaNV) AS SoLuongTV
FROM DuAn d, PhanCong p, NhanVien n
WHERE d.KinhPhi >= 4000
    AND d.MaDuAn = p.MaDuAn
    AND n.MaNV = p.MaNV
    AND n.MaChucVu LIKE 'TV'
GROUP BY d.MaDuAn, d.TenDuAn, d.KinhPhi, d.TGBD, d.TGKT);
-- 7
ALTER TABLE DuAn
ADD CONSTRAINT duration CHECK(DATEDIFF(year, TGBD, TGKT) <= 5);

ALTER TABLE ChucVu
ADD CONSTRAINT Luong CHECK(LuongNC BETWEEN 500 AND 3000);

-- DROP TABLE PhanCong
-- DROP TABLE NhanVien
-- DROP TABLE DuAn
-- DROP TABLE ChucVu