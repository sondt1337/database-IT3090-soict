CREATE TABLE PHICO (
    MAPC VARCHAR(10) NOT NULL PRIMARY KEY,
    TENPHICO VARCHAR(50) NOT NULL,
    KHOANGCACHBAY INT NOT NULL,
)

CREATE TABLE CHUYENBAY(
    MACB VARCHAR(10) NOT NULL PRIMARY KEY,
    MAPC VARCHAR(10) NOT NULL,
    NOIXP VARCHAR(50) NOT NULL,
    NoiDen VARCHAR(50) NOT NULL,
    GioXP DATETIME NOT NULL,
    GioDen DATETIME NOT NULL,
    FOREIGN KEY (MAPC) REFERENCES PHICO(MAPC)
)

CREATE TABLE NHANVIEN (
    MANV VARCHAR(10) NOT NULL PRIMARY KEY,
    HOTENNV NVARCHAR(100) NOT NULL,
    NGAYSINH DATETIME NOT NULL,
    DIACHI NVARCHAR(100) NOT NULL,
    LUONGCB INT NOT NULL,
)

CREATE TABLE CHITIET_CHUYENBAY (
    MACB VARCHAR(10) NOT NULL,
    MANV VARCHAR(10) NOT NULL,
    PRIMARY KEY (MACB, MANV),
    FOREIGN KEY (MACB) REFERENCES CHUYENBAY(MACB),
    FOREIGN KEY (MANV) REFERENCES NHANVIEN(MANV)
)

INSERT INTO PHICO VALUES 
('BL750', 'Airbus B320', 5000),
('QH228', 'Airbus B321', 1660),
('VJ144', 'Airbus C322', 2300),
('VN216', 'Airbus D323', 7000),
('VN238', 'Airbus D324', 5700),
('VN350', 'Airbus D325', 3000),
('VJ189', 'Airbus D326', 4000)

INSERT INTO CHUYENBAY VALUES 
('CBND.0001', 'VJ144', 'HANOI', 'TPHCM', '2019-10-24 07:00:00', '2019-10-24 10:00:00'),
('CBND.0002', 'QH228', 'HANOI', 'VINH', '2019-10-25 08:00:00', '2019-10-25 09:00:00'),
('CBND.0003', 'BL750', 'HANOI', 'DANANG', '2019-11-24 09:00:00', '2019-11-24 11:00:00'),
('CBND.0004', 'QH228', 'VINH', 'TPHCM', '2019-11-26 10:00:00', '2019-11-26 14:00:00'),
('CBND.0005', 'VN350', 'DANANG', 'VINH', '2019-11-20 11:00:00', '2019-11-20 12:00:00'),
('CBQT.0001', 'VN216', 'HANOI', 'TOKYO', '2020-01-24 07:00:00', '2020-01-24 13:00:00'),
('CBQT.0002', 'VN238', 'TOKYO', 'TPHCM', '2020-02-25 07:00:00', '2020-02-25 12:00:00'),
('CBQT.0003', 'VJ189', 'DANANG', 'TOKYO', '2020-03-24 15:00:00', '2020-03-24 23:00:00'),
('CBQT.0004', 'VN350', 'TOKYO', 'HANOI', '2020-03-15 17:00:00', '2020-03-16 02:00:00'),
('CBQT.0005', 'VJ189', 'SEOUL', 'HANOI', '2020-01-25 20:00:00', '2020-01-26 08:00:00'),
('CBQT.0006', 'VN350', 'HANOI', 'SEOUL', '2020-02-20 07:00:00', '2020-02-20 14:00:00')

INSERT INTO NHANVIEN VALUES
('MPC.001', N'Đào Duy Thịnh', '1985-05-15', N'30,Võ Nguyên Giáp', 50000),
('MPC.002', N'Phạm Thanh Bình','1985-05-13',N'17,Trần Nguyên Hãn', 70000 ),
('MPC.003', N'Nguyễn Thành Duy', '1904-05-12',N'253, Nguyễn Thái Học', 50000),
('MPC.004', N'Bùi Trọng Trung', '1981-05-10', N'32, Nguyễn Công Trứ', 70000),
('MPC.005', N'Nguyễn Đức Dũng', '1987-05-30', N'17, Hồ Xuân Hương', 70000),
('MTV.001', N'Nguyễn Hà Nam', '1989-05-10', N'78, Định Công', 45000),
('MTV.002', N'Nguyễn Duy Chung', '1980-10-28', N'34, Mỹ Đình', 45000),
('MTV.003', N'Nguyễn Đình Thuỷ', '1980-04-27', N'178, Láng Hạ', 35000),
('MTV.004', N'Đinh Thế Dũng', '1991-06-07', N'Gia Lâm', 35000),
('MTV.005', N'Ngô Tuấn Dũng', '1981-05-02', N'Hồ Hoàn Kiếm', 35000)


INSERT INTO CHITIET_CHUYENBAY VALUES
('CBND.0001', 'MPC.001'),
('CBND.0001', 'MTV.001'),
('CBND.0003', 'MPC.005'),
('CBND.0003', 'MTV.001'),
('CBQT.0001', 'MPC.004')

--1--
SELECT * 
FROM PHICO
WHERE KHOANGCACHBAY BETWEEN 1000 AND 5000

--2--
SELECT cb.MACB, cb.NOIXP, cb.NoiDen, cb.GioXP, cb.GioDen, pc.TENPHICO
FROM CHUYENBAY cb, CHITIET_CHUYENBAY cccb, PHICO pc
WHERE cb.MACB = cccb.MACB AND cb.MAPC = pc.MAPC
AND YEAR(cb.GioXP) = 2019
GROUP BY cb.MACB, cb.NOIXP, cb.NoiDen, cb.GioXP, cb.GioDen, pc.TENPHICO
HAVING COUNT(cccb.MANV) >= ALL(
    SELECT COUNT(cccb.MANV)
    FROM CHUYENBAY cb, CHITIET_CHUYENBAY cccb
    WHERE cb.MACB = cccb.MACB 
    AND YEAR(cb.GioXP) = 2019
    GROUP BY cb.MACB
)

--3--
SELECT nv.MANV, nv.HOTENNV,nv.DIACHI,
COUNT(cccb.MACB) AS 'Số chuyến bay',
COUNT(cccb.MACB) * nv.LUONGCB AS 'Tổng lương trong 6 tháng đâu năm 2020'
FROM NHANVIEN nv, CHITIET_CHUYENBAY cccb, CHUYENBAY cb
WHERE nv.MANV = cccb.MANV AND cccb.MACB = cb.MACB
AND (YEAR(cb.GioXP) = 2020 AND (MONTH(cb.GioXP) BETWEEN 1 AND 6))
GROUP BY nv.MANV, nv.HOTENNV,nv.DIACHI, nv.LUONGCB

--4--
SELECT MAPC, TENPHICO, KHOANGCACHBAY
FROM PHICO 
WHERE MAPC NOT IN (
    SELECT MAPC
    FROM CHUYENBAY
    WHERE YEAR(GioXP) BETWEEN 2012 AND 2019
)

--5--
SELECT nv.MANV, nv.HOTENNV, nv.NGAYSINH, COUNT(cccb.MACB) AS 'Số chuyến bay'
FROM NHANVIEN nv, CHITIET_CHUYENBAY cccb, CHUYENBAY cb
WHERE nv.MANV = cccb.MANV AND cccb.MACB = cb.MACB
AND YEAR(cb.GioXP) = 2019
GROUP BY nv.MANV, nv.HOTENNV, nv.NGAYSINH
HAVING COUNT(cccb.MACB) = (
    SELECT COUNT(MACB)
    FROM CHUYENBAY
    WHERE YEAR(GioXP) = 2019
)

--6--
SELECT nv.MANV, nv.HOTENNV, YEAR(GETDATE()) - YEAR(nv.NGAYSINH) AS 'Tuổi nhân viên',
COUNT(cccb.MACB) AS 'Số chuyến bay'
FROM NHANVIEN nv, CHITIET_CHUYENBAY cccb, CHUYENBAY cb, PHICO pc
WHERE nv.MANV = cccb.MANV AND cccb.MACB = cb.MACB AND cb.MAPC = pc.MAPC
AND YEAR(nv.NGAYSINH) BETWEEN 1984 AND 1989
AND pc.KHOANGCACHBAY >= 4000
GROUP BY nv.MANV, nv.HOTENNV, nv.NGAYSINH
HAVING COUNT(cccb.MACB) <= ALL(
    SELECT COUNT(cccb.MACB)
    FROM NHANVIEN nv, CHITIET_CHUYENBAY cccb, CHUYENBAY cb, PHICO pc
    WHERE nv.MANV = cccb.MANV AND cccb.MACB = cb.MACB AND cb.MAPC = pc.MAPC
    AND YEAR(nv.NGAYSINH) BETWEEN 1984 AND 1989
    AND pc.KHOANGCACHBAY >= 4000
    GROUP BY nv.MANV
)

--7--
ALTER TABLE PHICO
ADD CONSTRAINT CHECK_KHOANGCACHBAY
CHECK (KHOANGCACHBAY >= 500)

ALTER TABLE CHUYENBAY
ADD CONSTRAINT CHECK_GIOXP
CHECK (GioXP < GioDen)

