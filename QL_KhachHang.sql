-- A
-- 1
CREATE TABLE KhachHang
(
    MaKH VARCHAR(10) PRIMARY KEY,
    HoTen NVARCHAR(30),
    DiaChi NVARCHAR(30),
    SoDT VARCHAR(20),
    NgaySinh DATE
)

CREATE TABLE SanPham
(
    MaSP VARCHAR(30) PRIMARY KEY,
    TenSP NVARCHAR(30),
    DVT NVARCHAR(10),
    NuocSX NVARCHAR(30),
    DonGia INT
)

CREATE TABLE HoaDon
(
    SoHD VARCHAR(10) PRIMARY KEY,
    NgayHD DATE,
    MaKH VARCHAR(10),
    FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH)
)

CREATE TABLE CTHoaDon
(
    SoHD VARCHAR(10),
    MaSP VARCHAR(30),
    SL INT,
    CONSTRAINT KhoaChinh PRIMARY KEY (SoHD, MaSP),
    FOREIGN KEY (SoHD) REFERENCES HoaDon(SoHD),
    FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP)
)

-- 2
INSERT INTO KhachHang
VALUES
    ('HDG.001', N'Đào Duy Thịnh', N'Võ Nguyên Giáp', '0915962468', '1984-11-13'),
    ('HDG.002', N'Phạm Thanh Bình', N'Trần Nguyên Hãn', '0944639886', '1986-01-27'),
    ('HDG.003', N'Nguyễn Thành Duy', N'Nguyễn Thái Học', '0913277115', '1991-03-31'),
    ('HDG.004', N'Bùi Trọng Trung', N'Nguyễn Công Trứ', '0946647737', '1987-11-21'),
    ('HDG.005', N'Nguyễn Đức Dũng', N'Hồ Xuân Hương', '0916916995', '1989-05-09'),
    ('HNL.001', N'Nguyễn Thu Hà', N'Định Công', '01696966456', '1980-10-15'),
    ('HNL.002', N'Nguyễn Duy Chung', N'Mỹ Đình', '0914361566', '1980-10-28'),
    ('HNL.003', N'Nguyễn Thị Phương Thu', N'Láng Hạ', '0915111115', '1981-11-27'),
    ('HNL.004', N'Đinh Thế Dũng', N'Gia Lâm', '02439939399', '1991-04-04'),
    ('HNL.005', N'Ngô Tuấn Dũng', N'Hồ Hoàn Kiếm', '0916508272', '1981-09-25');

INSERT INTO SanPham
VALUES
    ('RUS.BINHNUOC', N'Bình nước', N'Chiếc', N'NGA', 80000),
    ('RUS.BINHHOA', N'Bình hoa', N'Chiếc', N'NGA', 150000),
    ('USA.MOCKHOA', N'Móc khóa', N'Chiếc', N'MỸ', 75000),
    ('USA.REMOTE', N'Điều khiển từ xa', N'Chiếc', N'MỸ', 125000),
    ('VNM.MOCTREO', N'Móc treo', N'Chiếc', N'VIỆT NAM', 15000),
    ('VNM.KHOACUA', N'Khóa cửa', N'Chiếc', N'VIỆT NAM', 75000),
    ('CAM.KHANRAN', N'Khăn rằn', N'Chiếc', N'CAMPUCHIA', 65000),
    ('MAS.MUBAOHIEM', N'Mũ bảo hiểm', N'Chiếc', N'MALAYSIA', 180000),
    ('MAS.AOBAOHIEM', N'Áo bảo hiểm', N'Chiếc', N'MALAYSIA', 350000),
    ('MAS.GIAUBAOHIEM', N'Giày bảo hiểm', N'Chiếc', N'MALAYSIA', 300000);

INSERT INTO HoaDon
VALUES
    ('81357', '2017-05-18', 'HDG.001'),
    ('81359', '2017-05-19', 'HNL.002'),
    ('81361', '2017-05-21', 'HDG.001'),
    ('81363', '2017-05-26', 'HDG.004'),
    ('81365', '2017-06-18', 'HDG.005'),
    ('81366', '2017-06-19', 'HNL.001'),
    ('81369', '2017-06-21', 'HNL.002'),
    ('81371', '2017-06-29', 'HDG.003'),
    ('81373', '2017-07-18', 'HNL.004'),
    ('81375', '2017-07-19', 'HNL.005');

INSERT INTO CTHoaDon
VALUES
    ('81357', 'RUS.BINHNUOC', 5),
    ('81359', 'RUS.BINHHOA', 1),
    ('81361', 'USA.MOCKHOA', 2),
    ('81363', 'USA.REMOTE', 3),
    ('81365', 'VNM.MOCTREO', 4),
    ('81366', 'VNM.KHOACUA', 1),
    ('81369', 'CAM.KHANRAN', 5),
    ('81371', 'MAS.MUBAOHIEM', 1),
    ('81373', 'MAS.AOBAOHIEM', 2),
    ('81375', 'MAS.GIAUBAOHIEM', 1);
-- B
-- 1
SELECT s.MaSP, s.TenSP, SUM(c.SL) AS TongSoLuong
FROM SanPham s, CTHoaDon c, HoaDon h
WHERE s.MaSP = c.MaSP
    AND h.SoHD = c.SoHD
    AND h.NgayHD BETWEEN '2017-08-01' AND '2017-08-31'
GROUP BY s.MaSP, s.TenSP;
-- 2
SELECT h.SoHD, h.NgayHD, k.HoTen, k.DiaChi, SUM(c.SL * s.DonGia) AS TongTien
FROM HoaDon h, KhachHang k, SanPham s, CTHoaDon c
WHERE h.MaKH = k.MaKH
    AND s.MaSP = c.MaSP
    AND h.SoHD = c.SoHD
    AND h.NgayHD = '2019-05-19'
GROUP BY h.SoHD, h.NgayHD, k.HoTen, k.DiaChi;
-- 3
SELECT s.MaSP, s.TenSP
FROM SanPham s, HoaDon h, CTHoaDon c
WHERE s.MaSP = c.MaSP
    AND h.SoHD = c.SoHD
    AND s.DonGia < 200000
    AND h.NgayHD BETWEEN '2017-01-01' AND '2017-12-31'
GROUP BY s.MaSP, s.TenSP
HAVING SUM(c.SL) >= ALL (
SELECT SUM(c.SL)
FROM SanPham s, HoaDon h, CTHoaDon c
WHERE s.MaSP = c.MaSP
    AND h.SoHD = c.SoHD
    AND s.DonGia < 200000
    AND h.NgayHD BETWEEN '2017-01-01' AND '2017-12-31'
GROUP BY s.MaSP, s.TenSP 
);
-- 4
SELECT s.MaSP, s.TenSP
FROM SanPham s
WHERE NOT EXISTS (
SELECT c.SoHD
FROM HoaDon h, CTHoaDon c
WHERE h.SoHD = c.SoHD
    AND h.NgayHD BETWEEN '2017-01-01' AND '2017-06-30'
    AND s.MaSP = c.MaSP
);
-- 5
SELECT k.MaKH, k.HoTen, k.DiaChi, COUNT(h.SoHD) AS SoLanMua, SUM(c.SL * s.DonGia) AS TongTien
FROM KhachHang k, HoaDon h, CTHoaDon c, SanPham s
WHERE k.MaKH = h.MaKH
    AND s.MaSP = c.MaSP
    AND h.SoHD = c.SoHD
    AND YEAR(h.NgayHD) = 2017
GROUP BY k.MaKH, k.HoTen, k.DiaChi
HAVING SUM(c.SL * s.DonGia) > 2000000;
-- 6
SELECT k.MaKH, k.HoTen, k.DiaChi, k.NgaySinh
FROM KhachHang k, HoaDon h, CTHoaDon c, SanPham s
WHERE k.MaKH = h.MaKH
    AND s.MaSP = c.MaSP
    AND h.SoHD = c.SoHD
    AND YEAR(h.NgayHD) = 2017
    AND s.NuocSX LIKE N'VIỆT NAM'
GROUP BY k.MaKH, k.HoTen, k.DiaChi, k.NgaySinh
HAVING SUM(c.SL) >= ALL (
SELECT SUM(c.SL)
FROM KhachHang k, HoaDon h, CTHoaDon c, SanPham s
WHERE k.MaKH = h.MaKH
    AND s.MaSP = c.MaSP
    AND h.SoHD = c.SoHD
    AND YEAR(h.NgayHD) = 2017
    AND s.NuocSX LIKE N'VIỆT NAM'
GROUP BY k.MaKH, k.HoTen, k.DiaChi, k.NgaySinh
);
-- 7
ALTER TABLE HoaDon
ADD CONSTRAINT NgayMua CHECK (NgayHD < GETDATE());

ALTER TABLE KhachHang
ADD CONSTRAINT NamSinh CHECK (YEAR(NgaySinh) < 2012);